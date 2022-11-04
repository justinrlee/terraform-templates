# Forward all regular traffic to upstream DNS
.:53 {
    # Use local GCP resolver
    forward . 169.254.169.254
    log
    errors
    cache
}

glb.confluent.cloud:53 {
  # Rewrite bootstrap server glb to non-glb
  template IN ANY {
      match "^(?P<cid>[lp][a-z]+c-[a-z0-9]+)-(?P<nid>[a-z0-9]+)\.(?P<pre>.*)\.glb\.(?P<post>.*)\.$"
      answer "{{ .Name }} 301 IN CNAME {{ .Group.cid }}.{{ .Group.nid }}.{{ .Group.pre }}.{{ .Group.post }}."
      fallthrough
  }

  # Rewrite broker server glb to non-glb
  template IN ANY {
      match "^(?P<lkc>lkc-[a-z0-9]+|e)-(?P<last2>[a-f0-9]{4})-(?P<zone>[^.]+)-(?P<nid>[a-z0-9]+)\.(?P<pre>.*)\.glb\.(?P<post>.*)\.$"
      answer "{{ .Name }} 302 IN CNAME {{ .Group.lkc }}-{{ .Group.last2 }}.{{ .Group.zone }}.{{ .Group.nid }}.{{ .Group.pre }}.{{ .Group.post }}."
      fallthrough
  }
}

%{ for domain in domains ~}
# Handle non-glb addresses for g0xr9g
${domain}:53 {
  file ${domain}
    log
    errors
    cache
}
%{ endfor ~}