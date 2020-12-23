#
#
#
class profile_vault::firewall {
  firewall { '08200 allow vault UI and API':
    dport  => 8200,
    action => 'accept',
  }
  firewall { '08201 allow vault cluster':
    dport  => 8201,
    action => 'accept',
  }
}
