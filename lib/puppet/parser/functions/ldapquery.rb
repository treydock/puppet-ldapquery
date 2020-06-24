# Provides a query interface to an LDAP server
#
# @example simple query
#   ldapquery("(objectClass=dnsDomain)", ['dc'])
#
# @example more complex query for ssh public keys
#   ldapquery('(&(objectClass=ldapPublicKey)(sshPublicKey=*)(objectClass=posixAccount))', ['uid', 'sshPublicKey'])
#
require_relative '../../../puppet_x/ldapquery'

begin
  require 'net/ldap'
rescue
  Puppet.warn('Missing net/ldap gem required for ldapquery() function')
end

Puppet::Parser::Functions.newfunction(:ldapquery,
                                      type: :rvalue) do |args|

  if args.size > 3
    raise Puppet::ParseError, 'Too many arguments received in ldapquery()'
  end

  filter, attributes, opts = args

  attributes ||= []
  opts ||= {}
  base = opts['base'] || Puppet[:ldapbase]
  scope = opts['scope'] || 'sub'
  server = opts['server'] || Puppet[:ldapserver]

  return PuppetX::LDAPquery.new(filter, attributes, base, scope, server).results
end
