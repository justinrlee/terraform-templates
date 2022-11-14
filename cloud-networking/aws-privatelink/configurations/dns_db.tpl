$ORIGIN ${domain}.
@	3600 IN	SOA sns.dns.icann.org. noc.dns.icann.org. 2017042745 7200 3600 1209600 3600
	3600 IN NS a.iana-servers.net.
	3600 IN NS b.iana-servers.net.

%{ for endpoint in endpoints ~}
* 60 A ${endpoint}
%{ endfor ~}
