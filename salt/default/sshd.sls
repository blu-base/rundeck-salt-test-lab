{%- if "salt-minion" in grains.get("roles") %}

sshd_change_challengeresponseauth:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: "^ChallengeResponseAuthentication.*"
    - repl: "ChallengeResponseAuthentication yes"

{%- endif %}


# Fail safe for empty state
{{ sls }}_nop:
  test.nop: []
