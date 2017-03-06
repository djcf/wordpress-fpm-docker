This folder is aliased by nginx into hosts which use letsencrypt.

It's used by the LetsEncrypt CA as a challenge:

* First, we gen a certificate for some random $domain.
* Then we generate a signing request and send it to the CA
* The CA reads the signing request and challenges us to put some special key in the URL http://$domain/.well-known (nginx aliases that URL into this directory)
* If we are able to produce the key for consumption by the CA's HTTP client, the CA signs the certificate and allows us to serve with it

## See also

The vhost.j2 template in the ansible role vhost-renew.

H/T: Sherman, who developed this system for CommonWeal.