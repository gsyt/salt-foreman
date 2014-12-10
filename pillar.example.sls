foreman:
  proxy:
    package:
      upgrade: False
    require:
      - autofs
    service:
      manage: False
      enable: True
    config:
      manage: False
      source: salt://foreman/proxy/conf/settings.yml
      options:
        dhcp:
          enabled: False
          vendor: isc
          config: /etc/dhcp/dhcpd.conf
          subnets:
            - 192.168.0.0/255.255.255.0
          leases: /var/lib/dhcpd/dhcpd.leases
          keyname: foremanproxy
          keysecret: xxxx
        dns:
          enabled: False
          provider: nsupdate
          key: /etc/foreman/nsupdate.key
          server: xxxx
          ttl: 86400
        puppet:
          enabled: False
          conf: /etc/puppet/puppet.conf
        puppetca:
          enabled: False
          ssldir: /var/lib/puppet/ssl
          puppetdir: /etc/puppet
        tftp:
          enabled: False
          tftproot: /var/lib/tftpboot
          servername: 192.168.0.2
    lookup:
      package: foreman-proxy
      service: foreman-proxy
      config: /etc/foreman-proxy/settings.yml
      settings:
        dir: /etc/foreman-proxy/settings.d
        daemon: True
        pid: /var/run/foreman-proxy/foreman-proxy.pid
        port: 8443
        sslca: /var/lib/puppet/ssl/certs/ca.pem
        sslcert: /var/lib/puppet/ssl/certs/xxxx.pem
        sslkey: /var/lib/puppet/ssl/private_keys/xxxx.pem
        logfile: /var/log/foreman-proxy/proxy.log
        loglevel: DEBUG
        virsh_network: default
