TOGGLE = 'T'
SWITCH_ALL = '∀'
SWITCH_AROUND = '↕'
SWITCH_EXTREMES = 'C'


def switch_toggle(toggle_state):
  return '0' if toggle_state == '1' else '1'


def press_switch(toggle_index, level, state):
  """
  Switch the toggle at toggle_index, apply the changes, return the new state
  """
  toggle_type = level[toggle_index]

  if toggle_type == TOGGLE:
    new_state = state[:]
    new_state[toggle_index] = switch_toggle(new_state[toggle_index])
    return new_state
  elif toggle_type == SWITCH_ALL:
    return [switch_toggle(s) for s in state]
  elif toggle_type == SWITCH_AROUND:
    new_state = state[:]
    if toggle_index > 0:
      new_state[toggle_index - 1] = switch_toggle(new_state[toggle_index - 1])
    new_state[toggle_index] = switch_toggle(new_state[toggle_index])
    if toggle_index < len(state) - 1:
      new_state[toggle_index + 1] = switch_toggle(new_state[toggle_index + 1])
    return new_state
  else:
    raise Exception("Unknown toggle type: %s in %s" % (toggle_type, level))


def explore(level, state):
  """
  Explore current level
  """
  reachable_states = []
  for toggle_index in range(len(level)):
    # Store new state, and action that had to be taken to get there (actions are 1-indexed)
    reachable_states.append((press_switch(toggle_index, level, state), toggle_index + 1))

  return reachable_states


def solve_level(level, intial_state):
  """
  Find a way to solve specified level, or raise an Exception if problem has no solution
  """
  queue = []
  queue.append((intial_state, ''))
  known_states = set(intial_state)

  # Breadth first search algorithm, searching for a state of 111111
  while True:
    if len(queue) == 0:
      raise Exception("This level has no solution.")

    str_state, actions = queue.pop(0)
    state = list(str_state)
    new_states = explore(level, state)
    for new_state, new_action in new_states:
      new_actions = '%s%s' % (actions, new_action)
      # If everything is enabled, it's a win
      if all(i == "1" for i in new_state):
        return new_actions
      str_state = ''.join(new_state)
      if str_state not in known_states:
        queue.append((str_state, new_actions))
        known_states.add(str_state)


levels = (
  ('T', '0'),
  ('TTT∀', '0000'),
  ('T↕TT↕T', '000000'),
)

for level, initial_state in levels:
  if len(level) != len(initial_state):
    raise Exception("State and level must have the same length")

  solution = solve_level(level, initial_state)
  print("%s %s Level solution: %s" % (level.ljust(10), initial_state.ljust(10), solution))
