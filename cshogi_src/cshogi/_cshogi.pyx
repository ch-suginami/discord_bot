from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp cimport bool

import numpy as np
cimport numpy as np

import locale

dtypeHcp = np.dtype((np.uint8, 32))
dtypeEval = np.dtype(np.int16)
dtypeMove16 = np.dtype(np.int16)
dtypeGameResult = np.dtype(np.int8)

HuffmanCodedPos = np.dtype([
    ('hcp', dtypeHcp),
    ])

HuffmanCodedPosAndEval = np.dtype([
    ('hcp', dtypeHcp),
    ('eval', dtypeEval),
    ('bestMove16', dtypeMove16),
    ('gameResult', dtypeGameResult),
    ('dummy', np.uint8),
    ])

PackedSfen = np.dtype([
    ('sfen', np.uint8, 32),
    ])

PackedSfenValue = np.dtype([
    ('sfen', np.uint8, 32),
    ('score', np.int16),
    ('move', np.uint16),
    ('gamePly', np.uint16),
    ('game_result', np.int8),
    ('padding', np.uint8),
    ])

dtypeKey = np.dtype(np.uint64)
BookEntry = np.dtype([
    ('key', dtypeKey),
    ('fromToPro', dtypeMove16),
    ('count', np.uint16),
    ('score', np.int32),
	])


STARTING_SFEN = 'lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1'

SQUARES = [
	A1, B1, C1, D1, E1, F1, G1, H1, I1,
	A2, B2, C2, D2, E2, F2, G2, H2, I2,
	A3, B3, C3, D3, E3, F3, G3, H3, I3,
	A4, B4, C4, D4, E4, F4, G4, H4, I4,
	A5, B5, C5, D5, E5, F5, G5, H5, I5,
	A6, B6, C6, D6, E6, F6, G6, H6, I6,
	A7, B7, C7, D7, E7, F7, G7, H7, I7,
	A8, B8, C8, D8, E8, F8, G8, H8, I8,
	A9, B9, C9, D9, E9, F9, G9, H9, I9,
] = range(81)

SQUARE_NAMES = [
	'1a', '1b', '1c', '1d', '1e', '1f', '1g', '1h', '1i',
	'2a', '2b', '2c', '2d', '2e', '2f', '2g', '2h', '2i',
	'3a', '3b', '3c', '3d', '3e', '3f', '3g', '3h', '3i',
	'4a', '4b', '4c', '4d', '4e', '4f', '4g', '4h', '4i',
	'5a', '5b', '5c', '5d', '5e', '5f', '5g', '5h', '5i',
	'6a', '6b', '6c', '6d', '6e', '6f', '6g', '6h', '6i',
	'7a', '7b', '7c', '7d', '7e', '7f', '7g', '7h', '7i',
	'8a', '8b', '8c', '8d', '8e', '8f', '8g', '8h', '8i',
	'9a', '9b', '9c', '9d', '9e', '9f', '9g', '9h', '9i',
]

COLORS = [BLACK, WHITE] = range(2)

GAME_RESULTS = [
    DRAW, BLACK_WIN, WHITE_WIN,
] = range(3)

PIECE_TYPES_WITH_NONE = [NONE,
           PAWN,      LANCE,      KNIGHT,      SILVER,
         BISHOP,       ROOK,
           GOLD,
           KING,
      PROM_PAWN, PROM_LANCE, PROM_KNIGHT, PROM_SILVER,
    PROM_BISHOP,  PROM_ROOK,
] = range(15)

PIECE_TYPES = [
           PAWN,      LANCE,      KNIGHT,      SILVER,
         BISHOP,       ROOK,
           GOLD,
           KING,
      PROM_PAWN, PROM_LANCE, PROM_KNIGHT, PROM_SILVER,
    PROM_BISHOP,  PROM_ROOK,
]

PIECES = [NONE,
          BPAWN,      BLANCE,      BKNIGHT,      BSILVER,
        BBISHOP,       BROOK,
          BGOLD,
          BKING,
     BPROM_PAWN, BPROM_LANCE, BPROM_KNIGHT, BPROM_SILVER,
   BPROM_BISHOP,  BPROM_ROOK,       NOTUSE,       NOTUSE,
          WPAWN,      WLANCE,      WKNIGHT,      WSILVER,
        WBISHOP,       WROOK,
          WGOLD,
          WKING,
     WPROM_PAWN, WPROM_LANCE, WPROM_KNIGHT, WPROM_SILVER,
   WPROM_BISHOP, WPROM_ROOK,
] = range(31)

HAND_PIECES = [
          HPAWN,     HLANCE,     HKNIGHT,     HSILVER,
          HGOLD,
        HBISHOP,      HROOK,
] = range(7)

REPETITION_TYPES = [
    NOT_REPETITION, REPETITION_DRAW, REPETITION_WIN, REPETITION_LOSE,
    REPETITION_SUPERIOR, REPETITION_INFERIOR
] = range(6)

'''
	editted by ch_suginami at Kanjis and sizes from here
'''

SVG_PIECE_DEFS = [
	'<g id="black-pawn"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">歩</text></g>',
	'<g id="black-lance"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">香</text></g>',
	'<g id="black-knight"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">桂</text></g>',
	'<g id="black-silver"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">銀</text></g>',
	'<g id="black-gold"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">金</text></g>',
	'<g id="black-bishop"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">角</text></g>',
	'<g id="black-rook"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">飛</text></g>',
	'<g id="black-king"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">玉</text></g>',
	'<g id="black-pro-pawn"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">と</text></g>',
	'<g id="black-pro-lance"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">杏</text></g>',
	'<g id="black-pro-knight"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">圭</text></g>',
	'<g id="black-pro-silver"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">全</text></g>',
#	'<g id="black-pro-lance" transform="scale(1.0, 0.5)"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="10">成</text><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="60">香</text></g>',
#	'<g id="black-pro-knight" transform="scale(1.0, 0.5)"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="10">成</text><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="60">桂</text></g>',
#	'<g id="black-pro-silver" transform="scale(1.0, 0.5)"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="10">成</text><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="60">銀</text></g>',
	'<g id="black-horse"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">馬</text></g>',
	'<g id="black-dragon"><text font-family="serif" font-size="72" text-anchor="middle" x="100" y="100">龍</text></g>',
	'<g id="white-pawn" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">歩</text></g>',
	'<g id="white-lance" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">香</text></g>',
	'<g id="white-knight" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">桂</text></g>',
	'<g id="white-silver" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">銀</text></g>',
	'<g id="white-gold" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">金</text></g>',
	'<g id="white-bishop" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">角</text></g>',
	'<g id="white-rook" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">飛</text></g>',
	'<g id="white-king" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">玉</text></g>',
	'<g id="white-pro-pawn" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">と</text></g>',
	'<g id="white-pro-lance" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">杏</text></g>',
	'<g id="white-pro-knight" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">圭</text></g>',
	'<g id="white-pro-silver" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">全</text></g>',
#	'<g id="white-pro-lance" transform="scale(1.0, 0.5) rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-10">成</text><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="40">香</text></g>',
#	'<g id="white-pro-knight" transform="scale(1.0, 0.5) rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-10">成</text><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-40">桂</text></g>',
#	'<g id="white-pro-silver" transform="scale(1.0, 0.5) rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-10">成</text><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="40">銀</text></g>',
	'<g id="white-horse" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">馬</text></g>',
	'<g id="white-dragon" transform="rotate(180)"><text font-family="serif" font-size="72" text-anchor="middle" x="-100" y="-50">龍</text></g>',
]
SVG_PIECE_DEF_IDS = [None,
	"black-pawn", "black-lance", "black-knight", "black-silver",
	"black-bishop", "black-rook",
	"black-gold",
	"black-king",
	"black-pro-pawn", "black-pro-lance", "black-pro-knight", "black-pro-silver",
	"black-horse", "black-dragon", None, None,
	"white-pawn", "white-lance", "white-knight", "white-silver",
	"white-bishop", "white-rook",
	"white-gold",
	"white-king",
	"white-pro-pawn", "white-pro-lance", "white-pro-knight", "white-pro-silver",
	"white-horse", "white-dragon",
]
NUMBER_JAPANESE_NUMBER_SYMBOLS = [ None, '１', '２', '３', '４', '５', '６', '７', '８', '９' ]
NUMBER_JAPANESE_KANJI_SYMBOLS = [ None, "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八" ]
SVG_SQUARES = '<g stroke="black"><rect x="100" y="100" width="900" height="900" fill="none" stroke-width="1.5" /><line x1="100" y1="200" x2="1000" y2="200" stroke-width="1.0" /><line x1="100" y1="300" x2="1000" y2="300" stroke-width="1.0" /><line x1="100" y1="400" x2="1000" y2="400" stroke-width="1.0" /><line x1="100" y1="500" x2="1000" y2="500" stroke-width="1.0" /><line x1="100" y1="600" x2="1000" y2="600" stroke-width="1.0" /><line x1="100" y1="700" x2="1000" y2="700" stroke-width="1.0" /><line x1="100" y1="800" x2="1000" y2="800" stroke-width="1.0" /><line x1="100" y1="900" x2="1000" y2="900" stroke-width="1.0" /><line x1="200" y1="100" x2="200" y2="1000" stroke-width="1.0" /><line x1="300" y1="100" x2="300" y2="1000" stroke-width="1.0" /><line x1="400" y1="100" x2="400" y2="1000" stroke-width="1.0" /><line x1="500" y1="100" x2="500" y2="1000" stroke-width="1.0" /><line x1="600" y1="100" x2="600" y2="1000" stroke-width="1.0" /><line x1="700" y1="100" x2="700" y2="1000" stroke-width="1.0" /><line x1="800" y1="100" x2="800" y2="1000" stroke-width="1.0" /><line x1="900" y1="100" x2="900" y2="1000" stroke-width="1.0" /></g>'
SVG_COORDINATES = '<g><text font-family="serif" text-anchor="middle" font-size="72" x="150" y="70">9</text><text font-family="serif" text-anchor="middle" font-size="72" x="250" y="70">8</text><text font-family="serif" text-anchor="middle" font-size="72" x="350" y="70">7</text><text font-family="serif" text-anchor="middle" font-size="72" x="450" y="70">6</text><text font-family="serif" text-anchor="middle" font-size="72" x="550" y="70">5</text><text font-family="serif" text-anchor="middle" font-size="72" x="650" y="70">4</text><text font-family="serif" text-anchor="middle" font-size="72" x="750" y="70">3</text><text font-family="serif" text-anchor="middle" font-size="72" x="850" y="70">2</text><text font-family="serif" text-anchor="middle" font-size="72" x="950" y="70">1</text><text font-family="serif" text-anchor="middle" font-size="72" x="1060" y="175">一</text><text font-family="serif" text-anchor="middle" font-size="72" x="1060" y="275">二</text><text font-family="serif" text-anchor="middle" font-size="72" x="1060" y="375">三</text><text font-family="serif" text-anchor="middle" font-size="72" x="1060" y="475">四</text><text font-family="serif" text-anchor="middle" font-size="72" x="1060" y="575">五</text><text font-family="serif" text-anchor="middle" font-size="72" x="1060" y="675">六</text><text font-family="serif" text-anchor="middle" font-size="72" x="1060" y="775">七</text><text font-family="serif" text-anchor="middle" font-size="72" x="1060" y="875">八</text><text font-family="serif" text-anchor="middle" font-size="72" x="1060" y="975">九</text></g>'
PIECE_SYMBOLS = [
	'',
	'p', 'l', 'n', 's', 'b', 'r', 'g', 'k', '+p', '+l', '+n', '+s', '+b', '+r'
]
PIECE_JAPANESE_SYMBOLS = [
    '',
	'歩', '香', '桂', '銀', '角', '飛', '金', '玉', 'と', '杏', '圭', '全', '馬', '龍'
]
HAND_PIECE_JAPANESE_SYMBOLS = [
	"歩", "香", "桂", "銀",
	"金",
	"角", "飛"
]

'''
	editted by ch_suginami at Kanjis and sizes to
'''

class SvgWrapper(str):
	def _repr_svg_(self):
		return self

cdef extern from "init.hpp":
	void initTable()

initTable()

cdef extern from "position.hpp":
	cdef cppclass Position:
		@staticmethod
		void initZobrist()

Position.initZobrist()

cdef extern from "cshogi.h":
	void HuffmanCodedPos_init()
	void PackedSfen_init()
	void Book_init()

HuffmanCodedPos_init()
PackedSfen_init()
Book_init()

cdef extern from "cshogi.h":
	string __to_usi(const int move)
	string __to_csa(const int move)

def to_usi(int move):
	return __to_usi(move)

def to_csa(int move):
	return __to_csa(move)

cdef extern from "cshogi.h":
	cdef cppclass __Board:
		__Board() except +
		__Board(const string& sfen) except +
		__Board(const __Board& board) except +
		bool set(const string& sfen)
		bool set_hcp(char* hcp)
		bool set_psfen(char* psfen)
		void reset()
		string dump()
		void push(const int move)
		void pop(const int move)
		bool is_game_over()
		int isDraw(const int checkMaxPly)
		int move(const int from_square, const int to_square, const bool promotion)
		int drop_move(const int to_square, const int drop_piece_type)
		int move_from_usi(const string& usi)
		int move_from_csa(const string& csa)
		int move_from_move16(const unsigned short move16)
		int move_from_psv(const unsigned short move16)
		int turn()
		int ply()
		string toSFEN()
		void toHuffmanCodedPos(char* data)
		void toPackedSfen(char* data)
		int piece(const int sq)
		bool inCheck()
		int mateMoveIn1Ply()
		int mateMove(int ply);
		bool is_mate(int ply);
		unsigned long long getKey()
		bool moveIsPseudoLegal(const int move)
		bool moveIsLegal(const int move)
		vector[int] pieces_in_hand(const int color)
		vector[int] pieces()
		bool is_nyugyoku()
		void piece_planes(char* mem)
		void piece_planes_rotate(char* mem)
		bool isOK()
		unsigned long long bookKey()

	int __piece_to_piece_type(const int p)

cdef class Board:
	cdef __Board __board

	def __cinit__(self, str sfen=None, Board board=None):
		cdef string sfen_b
		if sfen:
			sfen_b = sfen.encode('ascii')
			self.__board = __Board(sfen_b)
		elif board is not None:
			self.__board = __Board(board.__board)
		else:
			self.__board = __Board()

	def __copy__(self):
		return Board(board=self)

	def copy(self):
		return Board(board=self)

	def set_sfen(self, str sfen):
		cdef string sfen_b = sfen.encode('ascii')
		self.__board.set(sfen_b)

	def set_hcp(self, np.ndarray hcp):
		return self.__board.set_hcp(hcp.data)

	def set_psfen(self, np.ndarray psfen):
		return self.__board.set_psfen(psfen.data)

	def reset(self):
		self.__board.reset()

	def __repr__(self):
		return self.__board.dump().decode('ascii')

	def push(self, int move):
		self.__board.push(move)

	def push_usi(self, str usi):
		cdef string usi_b = usi.encode('ascii')
		move = self.__board.move_from_usi(usi_b)
		self.__board.push(move)
		return move

	def push_csa(self, str csa):
		cdef string csa_b = csa.encode('ascii')
		cdef int move = self.__board.move_from_csa(csa_b)
		self.__board.push(move)
		return move

	def push_move16(self, unsigned short move16):
		cdef int move = self.__board.move_from_move16(move16)
		self.__board.push(move)
		return move

	def push_psv(self, unsigned short move16):
		cdef int move = self.__board.move_from_psv(move16)
		self.__board.push(move)
		return move

	def pop(self, int move):
		self.__board.pop(move)

	def is_game_over(self):
		return self.__board.is_game_over()

	def is_draw(self, ply=None):
		cdef int _ply
		if ply:
			_ply = ply
		else:
			_ply = 2147483647
		return self.__board.isDraw(_ply)

	def move(self, int from_square, int to_square, bool promotion):
		return self.__board.move(from_square, to_square, promotion)

	def drop_move(self, int to_square, int drop_piece_type):
		return self.__board.drop_move(to_square, drop_piece_type)

	def move_from_usi(self, str usi):
		cdef string usi_b = usi.encode('ascii')
		return self.__board.move_from_usi(usi_b)

	def move_from_csa(self, str csa):
		cdef string csa_b = csa.encode('ascii')
		return self.__board.move_from_csa(csa_b)

	def move_from_move16(self, unsigned short move16):
		return self.__board.move_from_move16(move16)

	def move_from_psv(self, unsigned short move16):
		return self.__board.move_from_psv(move16)

	@property
	def legal_moves(self):
		return LegalMoveList(self)

	@property
	def turn(self):
		return self.__board.turn()

	@property
	def move_number(self):
		return self.__board.ply()

	def sfen(self):
		return self.__board.toSFEN().decode('ascii')

	def to_hcp(self, np.ndarray hcp):
		return self.__board.toHuffmanCodedPos(hcp.data)

	def to_psfen(self, np.ndarray hcp):
		return self.__board.toPackedSfen(hcp.data)

	def piece(self, int sq):
		return self.__board.piece(sq)

	def piece_type(self, int sq):
		return 	__piece_to_piece_type(self.__board.piece(sq))

	def is_check(self):
		return self.__board.inCheck()

	def mate_move_in_1ply(self):
		return self.__board.mateMoveIn1Ply()

	def mate_move(self, int ply):
		assert ply % 2 == 1
		assert ply >= 3
		assert not self.__board.inCheck()
		return self.__board.mateMove(ply)

	def is_mate(self, int ply):
		assert ply % 2 == 0
		assert self.__board.inCheck()
		return self.__board.is_mate(ply)

	def zobrist_hash(self):
		return self.__board.getKey()

	def is_pseudo_legal(self, int move):
		return self.__board.moveIsPseudoLegal(move)

	def is_legal(self, int move):
		return self.__board.moveIsLegal(move)

	@property
	def pieces_in_hand(self):
		return (self.__board.pieces_in_hand(BLACK), self.__board.pieces_in_hand(WHITE))

	@property
	def pieces(self):
		return self.__board.pieces()

	def is_nyugyoku(self):
		return self.__board.is_nyugyoku()

	def piece_planes(self, np.ndarray features):
		return self.__board.piece_planes(features.data)

	def piece_planes_rotate(self, np.ndarray features):
		return self.__board.piece_planes_rotate(features.data)

	def is_ok(self):
		return self.__board.isOK()

	def book_key(self):
		return self.__board.bookKey()

	def to_svg(self, lastmove=None, scale=1.0):
		import xml.etree.ElementTree as ET

		width = 1200   #230
		height = 1000      #192

		svg = ET.Element("svg", {
			"xmlns": "http://www.w3.org/2000/svg",
			"version": "1.1",
			"xmlns:xlink": "http://www.w3.org/1999/xlink",
			"width": str(width * scale),
			"height": str(height * scale),
			"viewBox": "0 0 {} {}".format(width, height),
		})

'''
	editted by ch_suginami at positions and sizes from here
'''

		defs = ET.SubElement(svg, "defs")
		for piece_def in SVG_PIECE_DEFS:
			defs.append(ET.fromstring(piece_def))

		if lastmove is not None:
			i, j = divmod(move_to(lastmove), 9)
			ET.SubElement(svg, "rect", {
				"x": str(100 + (8 - i) * 100),
				"y": str(100 + j * 100),
				"width": str(100),
				"height": str(100),
				"fill": "#f6b94d"
			})
			if not move_is_drop(lastmove):
				i, j = divmod(move_from(lastmove), 9)
				ET.SubElement(svg, "rect", {
					"x": str(100 + (8 - i) * 100),
					"y": str(100 + j * 100),
					"width": str(100),
					"height": str(100),
					"fill": "#fdf0e3"
				})

		svg.append(ET.fromstring(SVG_SQUARES))
		svg.append(ET.fromstring(SVG_COORDINATES))

		for sq in SQUARES:
			pc = self.__board.piece(sq)
			if pc != NONE:
				i, j = divmod(sq, 9)
				x = 50 + (8 - i) * 100
				y = 75 + j * 100

				ET.SubElement(svg, "use", {
					"xlink:href": "#{}".format(SVG_PIECE_DEF_IDS[pc]),
					"x": str(x),
					"y": str(y),
				})

		hand_pieces = [[], []]
		for c in COLORS:
			i = 0
			for hp, n in zip(HAND_PIECES, self.__board.pieces_in_hand(c)):
				if n >= 2:
					if n >= 11:
						n -= 10
						hand_pieces[c].append((i, NUMBER_JAPANESE_KANJI_SYMBOLS[n]))
						i += 1
						hand_pieces[c].append((i, NUMBER_JAPANESE_KANJI_SYMBOLS[10]))
						i += 1
					else:
						hand_pieces[c].append((i, NUMBER_JAPANESE_KANJI_SYMBOLS[n]))
						i += 1
				if n >= 1:
					hand_pieces[c].append((i, HAND_PIECE_JAPANESE_SYMBOLS[hp]))
					i += 1
			i += 1
			hand_pieces[c].append((i, "手"))
			i += 1
			hand_pieces[c].append((i, "先" if c == BLACK else "後"))
			i += 1
			hand_pieces[c].append((i, "☗" if c == BLACK else "☖"))

		for c in COLORS:
			if c == BLACK:
				x = 1120 #214
				y = 70 #190
			else:
				x = -80 #-16
				y = -760 #-10
			scale = 1
			if len(hand_pieces[c]) + 1 > 13:
				scale = 13.0 / (len(hand_pieces[c]) + 1)
				if c == WHITE:
					y = -220
			elif len(hand_pieces[c]) > 4:
				if c == WHITE:
					y = -945 + 60 * len(hand_pieces[c])
			for i, text in hand_pieces[c]:
				e = ET.SubElement(svg, "text", {
					"font-family": "serif",
					"font-size": str(60 * scale),
				})
				e.set("x", str(x))
				if c == BLACK:
					e.set("y", str(y + 60 * scale * (len(hand_pieces[c]) - i)))
				else:
					e.set("y", str(y - 60 * scale * i))
				if c == WHITE:
					e.set("transform", "rotate(180)")
				e.text = text

		return SvgWrapper(ET.tostring(svg).decode("utf-8"))

'''
	editted by ch_suginami at Kanjis and sizes to
'''

	def _repr_svg_(self):
		return self.to_svg()

def piece_to_piece_type(int p):
	return __piece_to_piece_type(p)

cdef extern from "cshogi.h":
	cdef cppclass __LegalMoveList:
		__LegalMoveList() except +
		__LegalMoveList(const __Board& board) except +
		bool end()
		int move()
		void next()
		int size()

	int __move_to(const int move)
	int __move_from(const int move)
	int __move_cap(const int move)
	bool __move_is_promotion(const int move)
	bool __move_is_drop(const int move)
	int __move_from_piece_type(const int move)
	int __move_drop_hand_piece(const int move)
	unsigned short __move16(const int move)
	unsigned short __move16_from_psv(const unsigned short move16)
	unsigned short __move16_to_psv(const unsigned short move16)
	int __move_rotate(const int move)
	string __move_to_usi(const int move)
	string __move_to_csa(const int move)

cdef class LegalMoveList:
	cdef __LegalMoveList __ml

	def __cinit__(self, Board board):
		self.__ml = __LegalMoveList(board.__board)

	def __iter__(self):
		return self

	def __next__(self):
		if self.__ml.end():
			raise StopIteration()
		move = self.__ml.move()
		self.__ml.next()
		return move

	def __len__(self):
		return self.__ml.size()

def move_to(int move):
	return __move_to(move)

def move_from(int move):
	return __move_from(move)

def move_cap(int move):
	return __move_cap(move)

def move_is_promotion(int move):
	return __move_is_promotion(move)

def move_is_drop(int move):
	return __move_is_drop(move)

def move_from_piece_type(int move):
	return __move_from_piece_type(move)

def move_drop_hand_piece(int move):
	return __move_drop_hand_piece(move)

def move16(int move):
	return __move16(move)

def move16_from_psv(unsigned short move16):
	return __move16_from_psv(move16)

def move16_to_psv(unsigned short move16):
	return __move16_to_psv(move16)

def move_rotate(int move):
	return __move_rotate(move)

def move_to_usi(int move):
	return __move_to_usi(move).decode('ascii')

def move_to_csa(int move):
	return __move_to_csa(move).decode('ascii')

def opponent(color):
	return BLACK if color == WHITE else WHITE

cdef extern from "parser.h" namespace "parser":
	cdef cppclass __Parser:
		__Parser() except +
		string sfen
		string endgame
		vector[string] names
		vector[float] ratings
		vector[int] moves
		vector[int] scores
		int win
		void parse_csa_file(const string& path) except +
		void parse_csa_str(const string& csa_str) except +

cdef class Parser:
	cdef __Parser __parser

	def __cinit__(self):
		self.__parser = __Parser()

	def parse_csa_file(self, str path):
		cdef string path_b = path.encode(locale.getpreferredencoding())
		self.__parser.parse_csa_file(path_b)

	def parse_csa_str(self, str csa_str):
		cdef string csa_str_b = csa_str.encode('utf-8')
		self.__parser.parse_csa_str(csa_str_b)

	@property
	def sfen(self):
		return self.__parser.sfen.decode('ascii')

	@property
	def endgame(self):
		return self.__parser.endgame.decode('ascii')

	@property
	def names(self):
		return [name.decode('ascii') for name in self.__parser.names]

	@property
	def ratings(self):
		return self.__parser.ratings

	@property
	def moves(self):
		return self.__parser.moves

	@property
	def scores(self):
		return self.__parser.scores

	@property
	def win(self):
		return self.__parser.win
