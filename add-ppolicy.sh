#!/bin/bash

# This script is executed before slapd

cd /opt/custom-ldapconfig

# Load the ppolicy module and overlay. (modifying config database -n 0)
slapadd -F /bitnami/openldap/slapd.d/ -n 0 -l load-ppolicy.ldif

# This loads the default password/account policies. (modifying mdb database -n 2)
slapadd -F /bitnami/openldap/slapd.d/ -n 2 -l default-ppolicy.ldif