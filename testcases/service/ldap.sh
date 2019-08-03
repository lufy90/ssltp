#!/bin/bash
# 20190801
# Lufei

# create test files

PASSWORD=abc123
TMPDIR=${TMPDIR}/ldap.tmp

db_ldif=${TMPDIR}/db.ldif
monitor_ldif=${TMPDIR}/monitor.ldif
base_ldif=${TMPDIR}/base.ldif
user_ldif=${TMPDIR}/user.ldif

create_ldif(){
#  local db_ldif=$1
#  local monitor_ldif=$2
#  local base_ldif=$3
#  local user_ldif=$4
  


#  encrypted_password=$(slappasswd -h {SSHA} -s $PASSWORD) || \
#  {
#    echo create encrypted password FAILED.
#    return 2
#  }
  encrypted_password=abc
  # create config.ldif file
  cat > $db_ldif << EOF
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=itzgeek,dc=local

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=ldapadm,dc=itzgeek,dc=local

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $encrypted_password
EOF

  # create monitor.ldif file
  cat > $monitor_ldif << EOF
dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external, cn=auth" read by dn.base="cn=ldapadm,dc=itzgeek,dc=local" read by * none
EOF

  # create base.ldif file
  cat > $base_ldif << EOF
dn: dc=itzgeek,dc=local
dc: itzgeek
objectClass: top
objectClass: domain

dn: cn=ldapadm ,dc=itzgeek,dc=local
objectClass: organizationalRole
cn: ldapadm
description: LDAP Manager

dn: ou=People,dc=itzgeek,dc=local
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=itzgeek,dc=local
objectClass: organizationalUnit
ou: Group
EOF

  # create user.ldif file
  cat > $user_ldif << EOF
dn: uid=raj,ou=People,dc=itzgeek,dc=local
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: raj
uid: raj
uidNumber: 9999
gidNumber: 100
homeDirectory: /home/raj
loginShell: /bin/bash
gecos: Raj [Admin (at) ITzGeek]
userPassword: {crypt}x
shadowLastChange: 17058
shadowMin: 0
shadowMax: 99999
shadowWarning: 7
EOF
}

func1(){
  chk_rpm_exists openldap openldap-servers openldap-clients nss-pam-ldapd || return 65

  systemctl start slapd && systemctl is-active slapd > /dev/null || \
  {
    echo FAILED operation: systemctl start slapd
    return 1
  }

}

func2(){
  mkdir -p $TMPDIR || \
  {
    echo FAILED operation:  mkdir $TMPDIR 
    return 2
  }

  create_ldif
  ldapmodify -Y EXTERNAL  -H ldapi:/// -f $db_ldif
  ldapmodify -Y EXTERNAL  -H ldapi:/// -f $monitor_ldif
  cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG

  ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
  ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif 
  ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

}

func3(){

  # Create ognization
  echo $PASSWORD | ldapadd -x -W -D "cn=ldapadm,dc=itzgeek,dc=local" -f $base_ldif

  # create user in ldap database
  echo $PASSWORD | ldapadd -x -W -D "cn=ldapadm,dc=itzgeek,dc=local" -f $user_ldif

  # set user password
  echo $PASSWORD | ldappasswd -s $PASSWORD -W -D "cn=ldapadm,dc=itzgeek,dc=local" -x "uid=raj,ou=People,dc=itzgeek,dc=local"

  # search iterm
  ldapsearch -x cn=raj -b dc=itzgeek,dc=local
}

func4()
{
  chk_rpm_exists nss-pam-ldapd || return 65
  authconfig --enableldap --enableldapauth --ldapserver=localhost --ldapbasedn="dc=itzgeek,dc=local" --enablemkhomedir --update
  systemctl restart  nslcd
  getent passwd raj
 
}

func5()
{
  # login with ldap authenticated user
  :
}

clean()
{
  # delete created entries 
  ldapdelete -W -D "cn=ldapadm,dc=itzgeek,dc=local" "uid=raj,ou=People,dc=itzgeek,dc=local"

}
