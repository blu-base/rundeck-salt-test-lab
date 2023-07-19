include:
  - .additional


# Fail save if includes are empty
{{ sls }}_nop:
  test.nop: []
