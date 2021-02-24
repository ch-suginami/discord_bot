# -*- coding: utf-8 -*-

import datetime

# for debugging
import sys

#definition of constants
PIECES = ['歩', '香', '桂', '銀', '金', '角', '飛', '玉', 'と', '杏', '圭', '全', '馬', '龍', '・']
GOTE_PIECES = ['p', 'l', 'n', 's', 'g', 'b', 'r', 'k', '+p', '+l', '+n', '+s', '+b', '+r', ""]
SENTE_PIECES = ['P', 'L', 'N', 'S', 'G', 'B', 'R', 'K', '+P', '+L', '+N', '+S', '+B', '+R', ""]
KANJIS = ["", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八"]
NUMBERS = [ _ for _ in range(19)]

def conv_gote_pieces(pieces):
    sfen = ""
    for i in range(len(pieces)):
        num = 1
        kinds = PIECES.index(pieces[i][0])
        if len(pieces[i]) != 1:
            num = KANJIS.index(pieces[i][1:])
        kinds = GOTE_PIECES[kinds]
        num = NUMBERS[num]
        if num == 1:
            num = ""
        sfen += str(num) + str(kinds)
    return sfen

def conv_sente_pieces(pieces):
    sfen = ""
    for i in range(len(pieces)):
        num = 1
        kinds = PIECES.index(pieces[i][0])
        if len(pieces[i]) != 1:
            num = KANJIS.index(pieces[i][1:])
        kinds = SENTE_PIECES[kinds]
        num = NUMBERS[num]
        if num == 1:
            num = ""
        sfen += str(num) + str(kinds)
    return sfen

# from board BOD to sfen
def conv_board(board):
    sfen = ""
    brank = 0
    i = 0
    while i < len(board):
        if board[i] == "v":
        # count up first to find the piece
            i += 1
            if brank > 0:
                # output numbers
                sfen += str(brank)
            # reset the number
            brank = 0
            piece = PIECES.index(board[i])
            kind = GOTE_PIECES[piece]
            sfen += kind
            i += 1
        else:
            piece = PIECES.index(board[i])
            kind = SENTE_PIECES[piece]
            if kind == "":
                brank += 1
            else:
                if brank > 0:
                    sfen += str(brank) + kind
                else:
                    sfen += kind
                brank = 0
            i += 1
    if brank > 0:
        sfen += str(brank)
    return sfen

def kif2sfen(file_in):
    # main part
    with open(file_in, 'r', encoding="utf-8") as f:
        sfen = ""
        row = 0
        s_hand = ""
        g_hand = ""
        name = "(不詳)"
        jour = "(不詳)"
        while True:
            data = f.readline()
            if len(data) == 0:
                break
            if data == "# ----   saved by 東大将棋 詰将棋道場\n":
                name = "東大将棋"
                jour = "詰将棋道場"
            if data[:6] == "後手の持駒：":
                if data[6:] == "なし":
                    g_hand = ""
                else:
                    gote_hands = data[6:].split()
                    g_hand = conv_gote_pieces(gote_hands)
            if data[:6] == "先手の持駒：":
                if data[6:8] == "なし":
                    s_hand = ""
                else:
                    sente_hands = data[6:].split()
                    s_hand = conv_sente_pieces(sente_hands)
            if data[0] == "|":
                data = data[1:]
                data = data.split()
                data = "".join(data)
                print(data)
                if row == 8:
                    sfen += conv_board(data[:-2])
                else:
                    sfen += conv_board(data[:-2]) + "/"
                row += 1
            if data[:4] == "*作者：":
                name = data[4:]
            if data[:5] == "*発表誌：":
                jour = data[6:]
            if data[:2] == "手数":
                cnt = 0
                while True:
                    data2 = f.readline().split()
                    if data2 == []:
                        if cnt % 2 == 0:
                            cnt = cnt-1
                            break
                        else:
                            break
                    elif data2[0][0].isdecimal():
                        cnt += 1
                    elif data2[0][:4] == "*作者：":
                        name = "".join(data2)
                        name = name[0][4:]
                    elif data2[0][:5] == "*発表誌：":
                        jour = data[0][5:]
                    elif data2[0][0] == "*":
                        continue

    sfen = sfen + " b " + s_hand + g_hand + " 1"
    return [sfen, name, jour, cnt]

'''
args = sys.argv
sfen = kif2sfen(args[1])
print(sfen)
'''