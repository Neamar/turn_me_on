from solver import solve_level

levels = (
  ('T', '0'), # 1
  ('TTT∀', '0000'), # 4
  ('∀TT∀', '0110'), # 123
  ('T∀TT', '1011'), # 1234
  ('T↕TT↕T', '000000'), # 25
  ('T↕TT∀T', '111001'), # 256
  ('∀↕↕T', '1001'), #34
  ('T↕↕↕T', '10001'), # 3
  ('T↕TT∀T', '010101') # 123456
)

for index, (level, initial_state) in enumerate(levels):
  if len(level) != len(initial_state):
    raise Exception("State and level must have the same length")

  solution = solve_level(level, initial_state)
  print("%s %s %s Level solution: %s" % (str(index + 1).ljust(3), level.ljust(10), initial_state.ljust(10), solution))
