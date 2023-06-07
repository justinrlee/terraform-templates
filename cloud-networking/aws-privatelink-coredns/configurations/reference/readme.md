For CoreDNS zone files:

In CoreDNS, an A record that looks like this: `* 60 A <endpoint>` will resolve for all of the following:
*.domain
*.zone.domain

In 'spec' DNS you'd need to use a CNAME.
Also, within the cloud you want different records for each zone; with the external proxy, any proxy endpoint can forward traffic to any zone (and all will forward to the _right_ zone due to DNS in the zone itself). So we can get away with a single simple record.