#!/usr/bin/python
import json
import urllib2
import base64
import optparse

#username = "admin"
#password = "xxx"

parser = optparse.OptionParser(description="LDAP Configuration for Satellite")
# Required Arguments
requiredNamed = optparse.OptionGroup(parser,"required arguments")
requiredNamed.add_option("-u", "--user", type=str, help="admin user", action="store")
requiredNamed.add_option("-w", "--password", type=str, help="admin password", action="store")
requiredNamed.add_option("-n", "--name", type=str, help="Name of the LDAP connection (i.e.- MyLDAPConnection)", action="store")
requiredNamed.add_option("-l", "--ldaphost", type=str, help="LDAP host (fqdn)", action="store")
requiredNamed.add_option("-b", "--basedn", type=str, help="BaseDN (i.e.- OU=Users,DC=example,DC=com)", action="store")
requiredNamed.add_option("-o", "--attrlogin", type=str, help="Login attribute in LDAP (i.e.- sAMAccountName)", action="store")
requiredNamed.add_option("-f", "--attrfirstname", type=str, help="Firstname attribute in LDAP (i.e.- givenName)", action="store")
requiredNamed.add_option("-e", "--attrlastname", type=str, help="Lastname attribute in LDAP (i.e.- sn)", action="store")
requiredNamed.add_option("-m", "--attrmail", type=str, help="Mail attribute in LDAP (i.e.- email)", action="store")
parser.add_option_group(requiredNamed)
# Optional
parser.add_option("-s", "--satellite", type=str, help="Satellite host (localhost by default)", default='localhost')
parser.add_option("-p", "--port", type=int, help="LDAP port (636 by default)", default='636')
parser.add_option("-t", "--tls", type=str, help="TLS support (True by default)", default=True)
parser.add_option("-i", "--attrphoto", type=str, help="Photo attribute in LDAP (i.e.- photo) (empty by default)", default="")
parser.add_option("-r", "--register", type=str, help="Register in foreman (true by default)", default=True)
parser.add_option("-v", "--verbose", help="increase output verbosity", action='store_true')
(options, args) = parser.parse_args()
if not options.user:
        parser.error('User not given')
if not options.password:
        parser.error('Password not given')
if not options.name:
        parser.error('Name not given')
if not options.ldaphost:
        parser.error('Ldaphost not given')
if not options.basedn:
        parser.error('BaseDN not given')
if not options.attrlogin:
        parser.error('AttrLogin not given')
if not options.attrfirstname:
        parser.error('AttrFirstName not given')
if not options.attrlastname:
        parser.error('AttrLastName not given')
if not options.attrmail:
        parser.error('AttrMail not given')

# Default headers
headers = { 'Content-Type': "application/json", 'Accept': "application/json" }
# Host
host = "https://" + options.satellite

# Info to get
url = host + "/api/auth_source_ldaps"

# Create the json object
data = json.dumps(
{
    'name': options.name,
    'host': options.ldaphost,
    'port': options.port,
    'tls': options.tls,
    'base_dn': options.basedn,
    'account': '$login',
    'account_password': '',
    'attr_login': options.attrlogin,
    'attr_firstname': options.attrfirstname,
    'attr_photo': options.attrphoto,
    'attr_lastname': options.attrlastname,
    'attr_mail': options.attrmail,
    'onthefly_register': options.register
}
)

req = urllib2.Request(url,data,headers)
base64string = base64.encodestring('%s:%s' % (options.user, options.password)).replace('\n', '')
req.add_header("Authorization", "Basic %s" % base64string)  
response = urllib2.urlopen(req)
