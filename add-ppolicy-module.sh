#!/bin/bash

cd /opt/custom-ldapconfig
slapadd -F /bitnami/openldap/slapd.d/ -n 0 -l load-ppolicy.ldif