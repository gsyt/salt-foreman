salt-foreman
============

Salt formula to set up and configure [foreman] (http://theforeman.org/)

Parameters
------------
Please refer to example.pillar.sls for a list of available pillar configuration options

Usage
-----
- Apply state 'foreman' to install server to target minions
- Apply state 'foreman.proxy' to install proxy to target minions

Compatibility
-------------
- CentOS 6.x
- CentOS 7.x
- Ubuntu Trusty
- Ubuntu Utopic
