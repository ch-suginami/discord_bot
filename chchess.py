import chess
import cairosvg
import datetime
from PIL import Image, ImageDraw

cp_chess = Image.open("copyrights_1200_white.png")

def get_concat_v(im1, im2):
    dst = Image.new('RGB', (im1.width, im1.height + im2.height))
    dst.paste(im1, (0, 0))
    dst.paste(im2, (0, im1.height))
    return dst

# for chess board making
def chess_make_board(b_data, move=None):
    print(f'INFO: {datetime.datetime.now()}   FEN:{b_data}   Move:{move}', flush = True)
    wb = b_data[-5]
    try:
        last_move = chess.Move.from_uci(b_data[0])
    except ValueError:
        return -1
    FEN = " ".join(b_data[1:])
    if wb == "b":
        direction = True
    elif wb == "w":
        direction = False
    else:
        direction = None
    colors = {'square light': '#dee3e6', 'square dark': '#8ca2ad', 'square light lastmove': '#c3d887', 'dark light lastmove': '#92b166', 'margin': '#ffffff', 'coord': "#000000"}
    board = chess.Board(FEN)
    if move:
        move = chess.Move.from_uci(move)
        board.push(move)
        if wb == "w":
            direction = True
        elif wb == "b":
            direction = False
        else:
            direction = None
    check = None
    check_if = board.is_check()
    if check_if:
        check = board.king(not direction)
    svg = chess.svg.board(board, flipped=direction, check=check,
                            lastmove=last_move, size=1200, colors=colors)
#  png = "chess.png"
    # converting to the png file
    cairosvg.svg2png(svg, write_to="chess_base.png")
    chess_board = Image.open("chess_base.png")
    board = get_concat_v(chess_board, cp_chess)
    board.save("chess.png")
    return True
