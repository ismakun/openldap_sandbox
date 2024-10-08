Build and start the image with a volume to persist the ldif files we create:
https://drive.google.com/file/d/1kIEZZjXeDpH_9NXVBeVDYCB4ov3F2Lbf/view?usp=sharing


```
docker build -t openldap_sandbox .
docker volume create myData
docker run --rm --mount source=myData,target=/myData -e LDAP_EXTRA_SCHEMAS=cosine,inetorgperson,nis,ppolicy -e LDAP_CONFIG_ADMIN_ENABLED=yes openldap_sandbox
```

Attach to the container so we can test the ldif-tool (we do it as root):

```
docker ps
docker exec -u 0 -it <container id> /bin/bash
```

Now we can start testing! Run this:

```
slapcat -F /opt/bitnami/openldap/etc/slapd.d -n 2 -l /myData/oldData.ldif
vi /myData/oldData.ldif
```

At this point you can go ahead and add users or change attributes. I did something like this:

```
ldapadd -x -W -D "cn=admin,dc=example,dc=org" -H ldap://localhost:1389 -f /myData/modify.ldif
```

the admin's default password: adminpassword

Re run the slapcat command but with a different name for the output such as: 

```
slapcat -F /opt/bitnami/openldap/etc/slapd.d -n 2 -l /myData/newData.ldif
```

Now you can run the ldif-diff tool to generate the ldif file we will use to modify the database on a restart:

```
cd /myData
ldif-diff -s oldData.ldif -t newData.ldif -o results.ldif
```

Stop the container:

```
docker stop <container id>
```

Restart the container and attach yourself as root:

```
docker run --rm --mount source=myData,target=/myData openldap_sandboxdocker run --rm --mount source=myData,target=/myData -e LDAP_EXTRA_SCHEMAS=cosine,inetorgperson,nis,ppolicy -e LDAP_CONFIG_ADMIN_ENABLED=yes openldap_sandbox
docker ps
docker exec -u 0 -it <container id> /bin/bash
```

Now you have a clean LDAP database. Run the following command to update the database based on the diff results from earlier:

```
ldapmodify -x -W -D "cn=admin,dc=example,dc=org" -H ldap://localhost:1389 -f /myData/results.ldif
```

the admin's default password: adminpassword

Verify your database was updated:

```
slapcat -F /opt/bitnami/openldap/etc/slapd.d -n 2 -l /myData/latestData.ldif
vi /myData/latestData.ldif
```

Done!!
