#!/bin/bash

# Useful alias: alias dcls='docker container ls | awk "{ print \$1,  \$2 }"'
# Useful cleanup to get rid of EVERYTHING: docker container rm $(docker container ls -a | awk "{ print \$1 }")

# Note that the non-linear progression of port numbers skips commonly used ports
# SEE: https://web.mit.edu/rhel-doc/4/RH-DOCS/rhel-sg-en-4/ch-ports.html
#
#
# 2.6
#
docker run -d -p 80:80 -p 443:443 --name two-six-zero --restart=unless-stopped --privileged rancher/rancher:v2.6.0
docker run -d -p 81:80 -p 446:443 --name two-six-one --restart=unless-stopped --privileged rancher/rancher:v2.6.1
docker run -d -p 82:80 -p 447:443 --name two-six-two --restart=unless-stopped --privileged rancher/rancher:v2.6.2
docker run -d -p 83:80 -p 448:443 --name two-six-head --restart=unless-stopped --privileged rancher/rancher:v2.6-head
#
# 2.5
#
docker run -d -p 87:80 -p 451:443 --name two-five-seven --restart=unless-stopped --privileged rancher/rancher:v2.5.7
docker run -d -p 89:80 -p 452:443 --name two-five-ten --restart=unless-stopped --privileged rancher/rancher:v2.5.10
docker run -d -p 90:80 -p 453:443 --name two-five-eleven --restart=unless-stopped --privileged rancher/rancher:v2.5.11
docker run -d -p 91:80 -p 454:443 --name two-five-head --restart=unless-stopped --privileged rancher/rancher:v2.5-head
