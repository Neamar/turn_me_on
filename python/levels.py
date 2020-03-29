from solver import solve_level

levels = (
  ('T', '0'),
  ('TTT∀', '0000'),
  ('T↕TT↕T', '000000'),
  ('T↕TT∀T', '111001'),
  ('∀↕↕T', '1001'),
  ('T↕↕↕T', '10001'),
  ('T↕↕↕T', '10001'),
)

for level, initial_state in levels:
  if len(level) != len(initial_state):
    raise Exception("State and level must have the same length")

  solution = solve_level(level, initial_state)
  print("%s %s Level solution: %s" % (level.ljust(10), initial_state.ljust(10), solution))
