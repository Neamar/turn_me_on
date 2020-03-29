from itertools import product
from solver import solve_level

level = 'T↕TT∀T'
longest_solution_size = 0
best_option = []

for initial_state_arr in product(["0", "1"], repeat=len(level)):
  initial_state = ''.join(initial_state_arr)

  try:
    solution = solve_level(level, initial_state)
  except:
    continue
  if len(solution) > longest_solution_size:
    longest_solution_size = len(solution)
    best_option = (initial_state, solution)

print('Best option is initial_state %s, actions : %s (%s)' % (best_option[0], best_option[1], len(best_option[1])))
