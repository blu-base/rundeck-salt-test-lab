base:
  '*':
    - default
{#
  'roles:saltmaster':
    - match: grain
    - saltmaster

  'roles:minion':
    - match: grain
    - minion

  'roles:rundeck':
    - match: grain
    - rundeck

  'roles:postgres'
    - match: grain
    - postgres
#}
