from itertools import product
from solver import solve_level, press_switch
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


LEVEL_SIZE = 5
uninteresting_sequence = ''.join([str(i+1) for i in range(LEVEL_SIZE)])
for potential_level_arr in product(["T", "↕", "C", "%"], repeat=LEVEL_SIZE):
  if potential_level_arr[0] == "C" or potential_level_arr[-1] == "C":
    continue
  if potential_level_arr.count('%') < 2:
    continue
  if potential_level_arr.count('C') > 0 and potential_level_arr[0] == '%' and potential_level_arr[-1] == '%':
    continue

  potential_level = ''.join(potential_level_arr)
  if "%↕%" in potential_level:
    continue
  initial_state, solution = fuzz_level(potential_level)
  if len(solution) >= LEVEL_SIZE - 1 and solution != uninteresting_sequence:
    print('("%s", "%s") # %s (%s)' % (potential_level, initial_state, solution, len(solution)))

# print(press_switch(0, ['↕', '%', '%'], ['0', '0', '0']))
