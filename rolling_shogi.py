# -*- coding: utf-8 -*-

from re import DEBUG
from typing import NamedTuple
import shogi
import gammon
import kif2sfen
import discord
import chchess
import chess.svg
import cairosvg
import subprocess
import html
import random
import re
import datetime
import sys
from PIL import Image, ImageDraw

client = discord.Client()

# not for shown
TOKEN = ''
white = Image.open("white_1200.png")
cp_shogi = Image.open("copyrights_1200_white.png")
lichess_file = ["lichess_db_puzzle_v1.csv", "lichess_db_puzzle.csv"]
lichess_num = [125263, 1400194]
yaneura_file = ["yaneurao/mate3.sfen", "yaneurao/mate5.sfen", "yaneurao/mate7.sfen", "yaneurao/mate9.sfen", "yaneurao/mate11.sfen"]
yaneura_num = [998404, 998824, 999071, 999672, 999998]


def get_concat_v(im1, im2):
    dst = Image.new('RGB', (im1.width, im1.height + im2.height))
    dst.paste(im1, (0, 0))
    dst.paste(im2, (0, im1.height))
    return dst

@client.event
async def on_message(message):
    # initialize
    last_up = "No Information"
    last_name = "No Information"

    # 送信者がbotなら何もしない
    if message.author.bot:
        return

    ratio = message.content.split()
    # chess version
    if ratio[0] == ".chess" or ratio[0] == ".chchess":
        if ratio[1] == "board":
            png = chchess.chess_make_board(ratio[2:])
            if png != -1:
                await message.channel.send(file=discord.File("chess.png"))
            else:
                await message.channel.send("値が不正です。")
        elif ratio[1] == "tact":
            with open("chess_tactics.txt", 'r') as f:
                data_num = int(f.readline())
                rand_num = random.randint(1, data_num)
                data = None
                for _ in range(rand_num+1):
                    data = f.readline().split()
            png = chchess.chess_make_board(data[1:-1])
            await message.channel.send(f"ID:{data[0]}   {data[-1]}", file=discord.File("chess.png"))

    if ratio[0] == ".lichess":
        sfen = []
        sfen_data = ""
        move = ""
        prob_set = random.randint(0, 1)
        prob_id = random.randint(1, lichess_num[prob_set]+1)
        if prob_set == 0:
            with open(lichess_file[prob_set], 'r') as f:
                for _ in range(prob_id):
                    sfen = f.readline().split()
            move = sfen[0]
            sfen_data = [sfen[0], sfen[1], sfen[2], sfen[3], sfen[4], sfen[5], sfen[6]]
        elif prob_set == 1:
            with open(lichess_file[prob_set], 'r') as f:
                for _ in range(prob_id):
                    sfen = f.readline().split(",")
            move = sfen[2].split()
            move = move[0]
            sfen_data = sfen[1].split()
            sfen_data = [move, sfen_data[0], sfen_data[1], sfen_data[2], sfen_data[3], sfen_data[4], sfen_data[5]]
        png = chchess.chess_make_board(sfen_data, move)
        prob_id = f'Version: {prob_set + 1}   ID:{prob_id}'
        await message.channel.send(f'{prob_id}   FEN: {" ".join(sfen_data[1:])}', file=discord.File("chess.png"))

    # shogi version
    if ratio[0] == ".chshogi":
        white = Image.open("white_1200.png")
        if ratio[1] == "sfen":
            if len(ratio) == 2:
                sfen = "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
            else:
                sfen = " ".join(ratio[2:])
            png = shogi.shogi_make_board(sfen)
            shogi_board = Image.open("shogi_base.png")
            white.paste(shogi_board, mask=shogi_board)
            white.save("shogi.png")
            board = get_concat_v(white, cp_shogi)
            board.save("shogi.png")
            await message.channel.send(file=discord.File("shogi.png"))
        elif ratio[1] == "hirate":
            sfen = "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
            png = shogi.shogi_make_board(sfen)
            shogi_board = Image.open("shogi_base.png")
            white.paste(shogi_board, mask=shogi_board)
            white.save("shogi.png")
            board = get_concat_v(white, cp_shogi)
            board.save("shogi.png")
            await message.channel.send(file=discord.File("shogi.png"))
        white.close()

    # making board from kif like files
    if ratio[0] == ".notate":
        white = Image.open("white_1200.png")
        # cheking an attachments file
        if message.attachments:
            attachment = message.attachments[0]
            if attachment.url.endswith(('kif', 'kifu')):
                # save as file
                last_up = datetime.datetime.now()
                last_up = last_up.strftime('%Y年%m月%d日 %H時%M分%S秒')
                last_name = message.author
                await attachment.save("shogi.kif")
            else:
                await message.channel.send("Error: 現在未対応のファイル形式です。")
                return
        if len(ratio) == 2:
            sfen = shogi.kif_from_move("shogi.kif", int(ratio[1]))
        else:
            sfen = shogi.kif_from_move("shogi.kif")
        png = shogi.shogi_make_board(sfen[0])
        shogi_board = Image.open("shogi_base.png")
        white.paste(shogi_board, mask=shogi_board)
        white.save("shogi.png")
        board = get_concat_v(white, cp_shogi)
        board.save("shogi.png")
        await message.channel.send(f'この盤面は{last_up}に{last_name}にアップされた棋譜の{str(sfen[3])}手目を表しています。\n先手：{sfen[1]} - 後手：{sfen[2]} ', file=discord.File("shogi.png"))
        white.close()

    # mate problems from Yaneura-Oh
    if ratio[0] == ".yane":
        sfen = ""
        if len(ratio) != 2:
            await message.channel.send("Error: 手数を3～11の間で指定してください。")
            return
        white = Image.open("white_1200.png")
        if (not str.isdecimal(ratio[1])) or int(ratio[1]) < 0 or int(ratio[1]) % 2 == 0:
            await message.channel.send("Error: 数値を奇数で指定してください。")
            return
        elif int(ratio[1]) < 3 or int(ratio[1]) > 11:
            await message.channel.send("Error: 手数を3～11の間で指定してください。")
            return
        mate_num = int(ratio[1])//2 - 1
        total = yaneura_num[mate_num]
        rand1 = random.randint(1, total+1)
        with open(yaneura_file[mate_num], 'r') as f:
            for _ in range(rand1):
                sfen = f.readline()
        parsed_sfen = sfen.split()
        if parsed_sfen[-3] == "w":
            sfen = shogi.reversed_sfen(sfen)
        png = shogi.shogi_make_board(sfen)
        shogi_board = Image.open("shogi_base.png")
        white.paste(shogi_board, mask=shogi_board)
        white.save("shogi.png")
        board = get_concat_v(white, cp_shogi)
        board.save("shogi.png")
        await message.channel.send(f"出題:やねうら王データベース   ID:{rand1}   SFEN: {sfen}", file=discord.File("shogi.png"))
        white.close()

    if ratio[0] == ".gammon":
        if len(ratio) != 2:
            await message.channel.send(f"エラー： 正しい[XG/gnu]IDを入力してください。")
        else:
            XGID = ratio[1].split('`')
            judge = XGID[1].split(":")
            if judge[0:5] == "XGID=":
                XGID = judge[5:]
            elif judge[0:5] == "bgID=":
                judge = judge[5:].split(":")
                XGID = gammon.posID2XGID(judge[0])
                XGID += gammon.matchID2XGID(judge[1])
                judge = XGID.split(":")
                if judge[3] == "-1":
                    rev_pos = "".join(list(reversed(judge[0])))
                    judge[0] = rev_pos.swapcase()
                XGID = ":".join(judge)
            elif len(judge) == 2:
                XGID = gammon.posID2XGID(judge[0])
                XGID += gammon.matchID2XGID(judge[1])
                judge = XGID.split(":")
                if judge[3] == "-1":
                    rev_pos = "".join(list(reversed(judge[0])))
                    judge[0] = rev_pos.swapcase()
                XGID = ":".join(judge)
            elif len(judge) == 10:
                XGID = XGID

            XGID = "".join(XGID)
            print(f'INFO: XGID = {XGID}', flush = True)
            gammon = gammon.gammon_draw(XGID)
            XGID = XGID.split(":")
            you = int(XGID[5])
            oppo = int(XGID[6])
            craw = int(XGID[7])
            length = int(XGID[8])
            pnt_you = length - you
            pnt_oppo = length - oppo

            if pnt_you == 1 and not craw:
                craw = "Post Crawfold"
            elif pnt_oppo == 1 and not craw:
                craw = "Post Crawfold"

            if craw:
                craw = "Crawfold"
            else:
                craw = ""

            if gammon == True:
                await message.channel.send(f"ギャモン盤面   Match: {length} Point(s).   Score: {you}({pnt_you} away) - {oppo}({pnt_oppo} away) {craw}", file=discord.File("gammon.png"))

    if ratio[0] == ".chhelp":
        await message.channel.send(
            u"```.chess(=.chchess) board ([last_move] [FEN])     # Direct printing Figures\
      \n.chess(=.chchess) tact     # Chess tactics from my tactics' database\
      \n.lichess      # Chess tactics from lichess database(until 2/1/2021)\
      \n.chshogi [hirate|sfen] ([args])     # Making a shogi Board figure\
      \n.kif [move_number] <kif-file>     # Making a [shogi] board figure from kif file until n-moves\
      \n.yane [n]     # Making tsumeshogi from Yaneura-Oh database\
      \n.gammon `[XGID|gnuID]`     # Making Gammon board (must use with the symbol `)\
      \n  いいんちょボット v1.5 by 杉並委員長@ch_suginami```")

# 実行
client.run(TOKEN)
