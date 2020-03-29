TOGGLE = 'T'
SWITCH_ALL = '∀'
SWITCH_AROUND = '↕'
SWITCH_EXTREMES = 'C'


def switch_toggle(toggle_state):
  return '0' if toggle_state == '1' else '1'


def switch_state(toggle_index, state):
  """
  Switch one toggle at specified index
  """
  current_value = state[toggle_index]
  new_state = state[:]
  new_state[toggle_index] = switch_toggle(current_value)
  return new_state


def press_switch(toggle_index, level, state):
  """
  Switch the toggle at toggle_index, apply the changes, return the new state
  """
  toggle_type = level[toggle_index]

  if toggle_type == TOGGLE:
    return switch_state(toggle_index, state)
  elif toggle_type == SWITCH_ALL:
    return [switch_toggle(s) for s in state]
  else:
    raise Exception("Unknown toggle type: %s in %s" % (toggle_type, level))


def explore(level, state):
  """
  Explore current level
  """
  reachable_states = []
  for toggle_index in range(len(level)):
    reachable_states.append((press_switch(toggle_index, level, state), toggle_index))

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


solution = solve_level('TTT∀', '0000')
print("Level solution: %s" % solution)
