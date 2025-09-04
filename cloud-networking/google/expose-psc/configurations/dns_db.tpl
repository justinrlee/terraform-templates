$ORIGIN ${domain}.
@	3600 IN	SOA sns.dns.icann.org. noc.dns.icann.org. 2017042745 7200 3600 1209600 3600
	3600 IN NS a.iana-servers.net.
	3600 IN NS b.iana-servers.net.

%{ for zone, ip in zone_ip_mappings }
* 60 A ${ip}
*.${zone} 60 A ${ip}
%{ endfor ~}