TOGGLE = 'T'
SWITCH_ALL = '∀'
SWITCH_AROUND = '↕'
SWITCH_EXTREMES = 'C'
SWITCH_ABOVE = '⇑'
SWITCH_INTRICATE = '%'
SWITCH_NTH = 'N'


def switch(toggle_state):
  return '0' if toggle_state == '1' else '1'


def switch_toggle(toggle_index, state):
  state[toggle_index] = switch(state[toggle_index])


def press_switch(toggle_index, level, state):
  """
  Switch the toggle at toggle_index, apply the changes, return the new state
  """
  toggle_type = level[toggle_index]

  if toggle_type == TOGGLE:
    new_state = state[:]
    switch_toggle(toggle_index, new_state)
    return new_state
  elif toggle_type == SWITCH_ALL:
    return [switch(s) for s in state]
  elif toggle_type == SWITCH_AROUND:
    new_state = state[:]
    if toggle_index > 0:
      switch_toggle(toggle_index - 1, new_state)
    switch_toggle(toggle_index, new_state)
    if toggle_index < len(state) - 1:
      switch_toggle(toggle_index + 1, new_state)
    return new_state
  elif toggle_type == SWITCH_EXTREMES:
    new_state = state[:]
    switch_toggle(toggle_index, new_state)
    switch_toggle(0, new_state)
    switch_toggle(len(state) - 1, new_state)
    return new_state
  elif toggle_type == SWITCH_ABOVE:
    v = switch(state[toggle_index])
    return [v if i <= toggle_index else s for i, s in enumerate(state)]
  elif toggle_type == SWITCH_INTRICATE:
    v = switch(state[toggle_index])
    return [v if i == toggle_index else (s if level[i] != SWITCH_INTRICATE else switch(v)) for i, s in enumerate(state)]
  elif toggle_type == SWITCH_NTH:
    new_state = state[:]
    enabled_count = new_state.count("1")
    switch_toggle(toggle_index, new_state)
    switch_toggle(enabled_count, new_state)
    return new_state

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


def solve_level(level, initial_state):
  """
  Find a way to solve specified level, or raise an Exception if problem has no solution
  """
  queue = []
  queue.append((initial_state, ''))
  known_states = set(initial_state)

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
