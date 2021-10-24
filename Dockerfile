# The base image
FROM bitnami/openldap:latest

# Bitnami uses a minimal image, install things we need...
USER root
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
&& apt-get -y install --no-install-recommends libncurses5-dev \
libncursesw5-dev openjdk-11-jdk unzip vim
USER 1001

# Copy 3rd party libraries
RUN ["mkdir", "-p", "/opt/unboundedid/ldapsdk"]
COPY ./cots/unboundid-ldapsdk-6.0.2.zip /opt/unboundedid/ldapsdk
RUN ["unzip", "/opt/unboundedid/ldapsdk/unboundid-ldapsdk-6.0.2.zip", "-d", "/opt/unboundedid/ldapsdk"]

ENTRYPOINT [ "/opt/bitnami/scripts/openldap/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/openldap/run.sh" ]