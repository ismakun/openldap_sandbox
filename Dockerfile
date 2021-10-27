# The base image
FROM bitnami/openldap:2.4.59-debian-10-r102

# Bitnami uses a minimal image, install things we need...
USER root
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
&& apt-get -y install --no-install-recommends libncurses5-dev \
libncursesw5-dev openjdk-11-jdk unzip vim
USER 1001

# Copy LDIF files, schema and script to enable ppolicy
RUN ["mkdir", "-p", "/opt/custom-ldapconfig"]
COPY load-ppolicy.ldif /opt/custom-ldapconfig
COPY default-ppolicy.ldif /opt/custom-ldapconfig

# Copy script that adds the ppolicy overlay
COPY add-ppolicy.sh /docker-entrypoint-initdb.d

# Copy 3rd party libraries
RUN ["mkdir", "-p", "/opt/unboundedid/ldapsdk"]
COPY ./cots/unboundid-ldapsdk-6.0.2.zip /opt/unboundedid/ldapsdk
RUN ["unzip", "/opt/unboundedid/ldapsdk/unboundid-ldapsdk-6.0.2.zip", "-d", "/opt/unboundedid/ldapsdk"]

# Start OpenLDAP
ENTRYPOINT [ "/opt/bitnami/scripts/openldap/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/openldap/run.sh" ]