domaing-munging
=========

This role's function mainly revolves around taking two strings, one named `domains` and one named `zones`, and transforming their contents into lists named `domain_list` and `zone_list` respectively, the former of which is used extensively by other roles in this repository. Along the way, we want to make sure that the output list always contains items like `www.$domain` iff it is a top-level domain (but not if it is a subdomain of $domain_host) and that a subdomain of $domain_host always exists in the outputted lists.