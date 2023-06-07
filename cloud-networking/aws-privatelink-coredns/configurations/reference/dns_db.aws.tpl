$ORIGIN ${domain}.
@	3600 IN	SOA sns.dns.icann.org. noc.dns.icann.org. 2017042745 7200 3600 1209600 3600
	3600 IN NS a.iana-servers.net.
	3600 IN NS b.iana-servers.net.

; Simplified zone file: for external DNS, all traffic can go through any of the proxy endpoints
; In CoreDNS A record that looks like this: `* 60 A <endpoint>` will resolve for all of the following:
; *.domain
; *.zone.domain
; Note that this is not standard DNS; normally we would need a CNAME, normally wildcard records don't work for subdomains

%{ for endpoint in endpoints ~}
* 60 A ${endpoint}
%{ endfor ~}
