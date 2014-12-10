{% from "foreman/proxy/map.jinja" import proxy with context %}

{% set require = salt['pillar.get']('dhcpd:proxy:require', []) %}

{% set package = {
  'name': proxy.package,
  'upgrade': salt['pillar.get']('foreman:proxy:package:upgrade', False),
} %}

{% set service = {
  'name': proxy.service,
  'manage': salt['pillar.get']('foreman:proxy:service:manage', False), 
  'enable': salt['pillar.get']('foreman:proxy:service:enable', True), 
} %}

{% set config = {
  'manage': salt['pillar.get']('foreman:proxy:config:manage', False), 
  'contents': salt['pillar.get']('foreman:proxy:config:contents', ''),
  'source': salt['pillar.get']('foreman:proxy:config:source', 'salt://foreman/proxy/conf/settings.yml'),
} %}

foreman.proxy.installed:
  require:
    - sls: foreman.proxy.sysconfig
{% if require %}
  {% for sls in require %}
    - sls: {{ sls }}
  {% endfor %}
{% endif %}
{% if service.manage %}
    - sls: foreman.proxy.service
{% endif %}
{% if config.manage %}
    - sls: foreman.proxy.config
{% endif %}

foreman.proxy.pkg:
  pkg.{{ 'latest' if package.upgrade else 'installed' }}:
    - name: {{ package.name }}

foreman.proxy.sysconfig:
  require:
    - sls: foreman.proxy.pkg
  file.managed:
    - name: {{ proxy.sysconfig }}
    - template: jinja
    - source: salt://foreman/proxy/conf/sysconfig

{% if service.manage %}
foreman.proxy.service:
  service.{{ 'running' if service.enable else 'dead' }}:
    - name: {{ service.name }}
  require:
    - pkg: foreman.proxy.installed
  {% if config.manage %}
    - sls: foreman.proxy.config
  watch:
    - file: foreman.proxy.sysconfig
    - file: foreman.proxy.config
    - pkg: foreman.proxy.pkg
  {% else %}
  watch:
    - pkg: foreman.proxy.pkg
  {% endif %}
{% endif %}

{% if config.manage %}
foreman.proxy.config:
  file.managed:
    - name: {{ config.file }}
    - template: jinja
  {% if config.contents %}
    - contents_pillar: foreman.proxy:config:contents
  {% else %}
    - source: {{ config.source }}
  {% endif %}
{% endif %}
