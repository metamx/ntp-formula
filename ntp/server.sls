{% from "ntp/map.jinja" import ntp with context %}

include:
  - ntp

{% if salt['pillar.get']('ntp:ntpd_conf') %}
ntpd_conf:
  file:
    - managed
    - name: {{ ntp.ntpd_conf }}
    - source: {{ salt['pillar.get']('npt:ntpd_conf', 'salt://ntp/ntp.conf') }}
    - require:
      - pkg: ntp
{% endif %}

ntpd:
  service:
    {% if grains['env'] != 'provision' %}
    - running
    { % else %}
    - dead
    {% endif %}
    - name: {{ ntp.service }}
    - enable: True
    - require:
      - pkg: ntp
{% if salt['pillar.get']('ntp:ntpd_conf') %}
    - watch:
      - file: ntpd_conf
{% endif %}
