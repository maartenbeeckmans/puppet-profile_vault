#
#
#
class profile_vault::certs (
  Stdlib::Absolutepath $root_ca_file     = $::profile_vault::root_ca_file,
  Stdlib::Absolutepath $cert_file        = $::profile_vault::cert_file,
  Stdlib::Absolutepath $key_file         = $::profile_vault::key_file,
  Stdlib::Absolutepath $certs_dir        = $::profile_vault::certs_dir,
  Boolean              $use_puppet_certs = $::profile_vault::use_puppet_certs,
  Optional[String]     $root_ca_cert     = $::profile_vault::root_ca_cert,
  Optional[String]     $vault_cert       = $::profile_vault::vault_cert,
  Optional[String]     $vault_key        = $::profile_vault::vault_key,
) {
  file { $certs_dir:
    ensure => directory,
  }
  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['vault'],
  }

  if $use_puppet_certs {
    file { $root_ca_file:
      ensure => present,
      source => $facts['extlib__puppet_config']['main']['localcacert'],
    }
    file { $cert_file:
      ensure => present,
      source => $facts['extlib__puppet_config']['main']['hostcert'],
    }
    file { $key_file:
      ensure => present,
      source => $facts['extlib__puppet_config']['main']['hostprivkey'],
    }
  } else {
    file { $root_ca_file:
      ensure  => present,
      content => $root_ca_cert,
    }
    file { $cert_file:
      ensure  => present,
      content => $vault_cert,
    }
    file { $key_file:
      ensure  => present,
      content => $vault_key,
    }
  }
}
