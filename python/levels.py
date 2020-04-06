from solver import solve_level

levels = (
  ('T', '0'), # 1
  ('TTT∀', '0000'), # 4
  ('∀TT∀', '0110'), # 123
  ('T∀TT', '1011'), # 1234
  ## INTRODUCE ↕
  ('T↕TT↕T', '000000'), # 25
  ('T↕TT∀T', '111001'), # 256
  ('∀↕↕T', '1001'), #34
  ('T↕↕↕T', '10001'), # 3
  ('↕∀↕T∀', '10100'), # 1234
  ('T↕TT∀T', '010101'), # 123456
  # INTRODUCE C
  ('TCT', '000'), # 2
  ('∀↕CT', '0101'), # 34
  ('∀↕↕C↕', '10011'), # 14
  ('↕C∀∀C∀↕', '1000111'), # 12357
  ('TT↕∀∀C↕', '0011011'), # 2347
  ('↕↕∀↕↕∀', '000110'), # 145
  # INTRODUCE ⇑
  ('TTT⇑T', '01000'), # 45
  ('↕↕↕⇑C∀', '010000'), # 54
  ('∀⇑⇑∀', '1000'), # 122
  ('⇑⇑∀⇑∀T', '001001'), # 3446
  # INTRODUCE N
  ('T↕↕N', '0010'), # 24
  ('∀↕↕CTN', '001000'), # 646
  ('NC∀∀', '0011'), # 12121
  ('↕↕N↕', '0101'), # 123324
  ('⇑↕N↕', '0101'), # 1243124
  ('T∀N∀∀∀', '001110'), #13123233313
)

for index, (level, initial_state) in enumerate(levels):
  if len(level) != len(initial_state):
    raise Exception("State and level must have the same length")

  solution = solve_level(level, initial_state)
  print("%s %s %s Level solution: %s" % (str(index + 1).ljust(3), level.ljust(10), initial_state.ljust(10), solution))
