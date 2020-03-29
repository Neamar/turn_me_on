from itertools import product
from solver import solve_level
from random import random

def fuzz_level(level):
  longest_solution_size = 0
  best_option = ['', -1]

  for initial_state_arr in product(["0", "1"], repeat=len(level)):
    initial_state = ''.join(initial_state_arr)

    try:
      solution = solve_level(level, initial_state)
    except:
      continue
    if len(solution) > longest_solution_size:
      longest_solution_size = len(solution)
      best_option = (initial_state, solution)
  return best_option


for potential_level_arr in product(["T", "N", "∀", "↕", "C"], repeat=6):
  if potential_level_arr[0] == "C" or potential_level_arr[-1] == "C":
    continue

  potential_level = ''.join(potential_level_arr)
  initial_state, solution = fuzz_level(potential_level)
  print('%s Best option is initial_state %s, actions : %s (%s)' % (potential_level, initial_state, solution, len(solution)))
