#cloud-config
fqdn: ${hostname}.${dnsdomain}
ssh_pwauth: true
chpasswd: false

runcmd:
  - nmcli connection del ens4
  - nmcli connection modify uuid $(nmcli -t -f uuid connection show |awk 'NR==1') con-name ens3 ipv4.addresses ${ipv4_address}/${ipv4_maskbits} ipv4.gateway ${ipv4_gateway} ipv4.method manual ipv4.dns ${ipv4_nameservers} ipv4.dns-search ${dnsdomain}
  - nmcli connection migrate
  - touch /etc/cloud/cloud-init.disabled
  - sleep 5
  - reboot
