#
#
#
class profile_vault::server (
  String               $advertise_address = $::profile_vault::advertise_address,
  Stdlib::Absolutepath $cert_file         = $::profile_vault::cert_file,
  Stdlib::Absolutepath $key_file          = $::profile_vault::key_file,
  Stdlib::Absolutepath $root_ca_file      = $::profile_vault::root_ca_file,
  Stdlib::Absolutepath $consul_cert_file  = $::profile_consul::cert_file,
  Boolean              $enable_ui         = $::profile_vault::enable_ui,
  Boolean              $manage_sd_service = $::profile_vault::manage_sd_service,
  String               $sd_service_name   = $::profile_vault::sd_service_name,
  Array                $sd_service_tags   = $::profile_vault::sd_service_tags,
  String               $config_dir        = $::profile_vault::config_dir,
  String               $version           = $::profile_vault::version,
) {
  $_listener = {
    'tcp' => {
      'address'         => "${advertise_address}:8200",
      'cluster_address' => "${advertise_address}:8201",
      'tls_disable'     => 0,
      'tls_cert_file'   => $cert_file,
      'tls_key_file'    => $key_file,
    },
  }

  $_storage = {
    'consul' => {
      'scheme'      => 'https',
      'address'     => '127.0.0.1:8500',
      'path'        => 'vault/',
      'tls_ca_file' => $consul_cert_file,
    }
  }

  if $enable_ui {
    $_extra_config = {
      'ui' => true,
    }

    if $manage_sd_service {
      consul::service { $sd_service_name:
        checks => [
          {
            http     => "https://${advertise_address}:8200",
            interval => '10s'
          }
        ],
        port   => 8200,
        tags   => $sd_service_tags,
      }
    }
  } else {
    $_extra_config = {}
  }

  $_telemetry = {
    'prometheus_retention_time' => '5m',
  }

  class { 'vault':
    config_dir          => $config_dir,
    enable_ui           => $enable_ui,
    extra_config        => $_extra_config,
    listener            => $_listener,
    manage_storage_dir  => false,
    storage             => $_storage,
    telemetry           => $_telemetry,
    version             => $version,
    manage_service_file => true,
    install_method      => 'repo',
    bin_dir             => '/usr/bin',
    api_addr            => "https://${advertise_address}:8200"
  }

  file { '/etc/profile.d/vault.sh':
    ensure  => file,
    mode    => '0644',
    content => "export VAULT_ADDR=https://${advertise_address}:8200\n export VAULT_CACERT=${root_ca_file}",
  }
}
