{%- if grains.get("additional_repos", {}) %}
  {%- for label, url in grains["additional_repos"].items() %}

{{ label }}_repo:
  pkgrepo.managed:
    - humanname: {{ label }}
    - baseurl: {{ url }}
    - refresh: True
    - priority: 95
    - gpgcheck: 0

  {%- endfor %}
{%- endif %}

{#
{%- if grains.get("additional_certs", {} %}
  {%- for label, url in grains["additional_certs"].items() %}

{{ label }}_cert:
  file.managed:
    - name: /

  {%- endfor %}
{%- endif %}
#}


# Fail safe for empty state
{{ sls }}_nop:
  test.nop: []
