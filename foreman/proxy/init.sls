include:
  - foreman.proxy.installed

foreman.proxy:
  require:
    - sls: foreman.proxy.installed
