# -*- coding: utf-8 -*-

input_f = "lichess_db_puzzle_v1.json"
output_f = "lichess_db_puzzle_v1.csv"

line = 0
with open(input_f, 'r') as f1:
  with open(output_f, 'w') as f2:
    fen = ""
    hist = ""
    while True:
      line += 1
      data = f1.readline().split("\"")
      if not data:
        break
      elif len(data) > 2 and data[1] == "fen":
        fen = data[3]
      elif len(data) > 2 and data[1] == "history":
        hist = data[-2].split()
      if fen != "" and hist != "":
#        print(f'{hist[-1]} {fen}')
        f2.write(f'{hist[-1]} {fen}\n')
        f2.flush()
        fen = ""
        hist = ""
      if line % 1000 == 0:
        print(line)