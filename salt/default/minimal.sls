include:
  {%- if grains["hostname"] and grains["domain"] %}
  - .hostname
  {%- endif %}
  - .network
  #  - .firewall
  - .time
  {%- if "build_image" not in grains.get("product_version") | default("", true) %}
  - repos
  {%- endif %}

minimal_package_update:
  pkg.latest:
    - pkgs:
      - salt-minion
    - order: last
