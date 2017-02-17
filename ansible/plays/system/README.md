REQUIREMENTS

Take note of the first requirement in install-web.yml: marvinpinto.docker. At the moment, docker 1.12 (?) has a bug in Ubuntu which prevents docker from linking containers with dots in their name. When the package maintainers update docker in the apt repositories we can remove this requirement and install normally using apt-get in the install-general role.