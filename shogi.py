# -*- coding: utf-8 -*-

import cshogi
import cshogi.KIF
import datetime
import html
import cairosvg
import sys, subprocess

# revering sfen
def reversed_sfen(sfen):
    parts_sfen = sfen.split()
    rev_sfen = list(reversed(parts_sfen[0]))
    for i in range(len(rev_sfen)):
        if rev_sfen[i] == "+":
            rev_sfen[i-1], rev_sfen[i] = rev_sfen[i], rev_sfen[i-1]
    rev_sfen = "".join(rev_sfen).swapcase()
    rev_hand = str(parts_sfen[-2]).swapcase()
    swap_sfen = rev_sfen + " b " + rev_hand + " " + parts_sfen[-1]
    return swap_sfen

# for shogi board making
def shogi_make_board(sfen):
    print(f'INFO: {datetime.datetime.now()}   SFEN:{sfen}', flush = True)
    board = cshogi.Board(sfen)
    svg = html.unescape(board.to_svg())
    cairosvg.svg2png(svg, write_to="shogi_base.png")
    return True

# from kif to extract move information
def kif_from_move(f_name, move_n = -1):
    # converting to UTF-8
    commands = ['nkf', '-wd', '--cp932', '--overwrite', f_name]
    proc = subprocess.run(commands, stdout = sys.stdout, stderr = sys.stdout)

    # making sfen
    board = cshogi.Board()
    kif = cshogi.KIF.Parser.parse_file(f_name)[0]
    move = kif['moves']
    if move_n < 0 or move_n > len(move):
        move_n = len(move)
    for i in range(move_n):
        board.push_usi(move[i])
    return [board.sfen(), kif['names'][cshogi.BLACK], kif['names'][cshogi.WHITE], move_n]