# OpenLDAP Install and Configure #

Install Software

	yum install -y openldap openldap-clients openldap-servers

Create an Admin password

	slappasswd -s PASSWORD -n > /etc/openldap/passwd

Generate database files (don’t worry about error messages!):

	slaptest

Change LDAP database ownership

	chown ldap:ldap /var/lib/ldap/*

Ensure the directory start at boot time

	systemctl enable slapd

Start the directory server

	systemctl start slapd

Add schemas to the directory

	cd /etc/openldap/schema
	ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f cosine.ldif
	ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f nis.ldif
	ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f inetorgperson.ldif
	wget https://www.switch.ch/aai/docs/eduperson.ldif
	ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f eduperson.ldif

Create a change file that will be applied to the directory. This will setup the Manager account, `changes.ldif`

	dn: olcDatabase={2}hdb,cn=config
	changetype: modify
	replace: olcSuffix
	olcSuffix: dc=trs,dc=edu,dc=au

	dn: olcDatabase={2}hdb,cn=config
	changetype: modify
	replace: olcRootDN
	olcRootDN: dc=trs,dc=edu,dc=au

	dn: olcDatabase={2}hdb,cn=config
	changetype: modify
	replace: olcRootPW
	olcRootPW: passwd # previously generated password (see above)

	dn: cn=config
	changetype: modify
	replace: olcLogLevel
	olcLogLevel: -1

	dn: olcDatabase={1}monitor,cn=config
	changetype: modify
	replace: olcAccess
	olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read by dn.base="cn=Manager,dc=trs,dc=edu,dc=au" read by * none

Make changes to the directory

	ldapmodify -Y EXTERNAL -H ldapi:/// -f changes.ldif

Create a change file that will create the structure in the directory.

	dn: dc=trs,dc=edu,dc=au
	dc: trs
	objectClass: top
	objectClass: domain

	dn: ou=People,dc=trs,dc=edu,dc=au
	ou: People
	objectClass: top
	objectClass: organizationalUnit

Add users...