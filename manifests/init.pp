#
class profile_vault (
  String                     $config_dir = '/etc/vault.d',
  Boolean                    $enable_ui = true,
  Variant[Hash, Array[Hash]] $listener = {
    'tcp' => {
      'address'         => '127.0.0.1:8200',
      'cluster_address' => '127.0.0.1:8201',
      'tls_disable'     => 1,
    },
  },
  Hash                       $extra_config = {
    'api_addr'     => 'https://127.0.0.1:8200',
    'cluster_addr' => 'https://127.0.0.1:8201'
  },
  Boolean                     $manage_firewall_entry = true,
  Boolean                     $manage_sd_service     = false,
  Boolean                     $manage_storage_dir    = true,
  String                      $sd_service_name       = 'vault-ui',
  Array                       $sd_service_tags       = ['metrics'],
  Hash                        $storage               = {
    'consul' => {
      'address' => '127.0.0.1:8500',
      'path'    => 'vault/'
    }
  },
  Optional[Hash]              $telemetry            = undef,
  String                      $version              = '1.5.5',
){
  class {'vault':
    config_dir         => $config_dir,
    enable_ui          => $enable_ui,
    extra_config       => $extra_config,
    listener           => $listener,
    manage_storage_dir => $manage_storage_dir,
    storage            => $storage,
    telemetry          => $telemetry,
    version            => $version,
    install_method     => 'repo',
  }

  if $manage_firewall_entry {
    firewall { '08200 allow vault UI and API':
      port   => 8200,
      action => 'accept',
    }
    firewall { '08201 allow vault cluster':
      port   => 8201,
      action => 'accept',
    }
  }
  if $manage_sd_service {
    consul::service { $sd_service_name:
      checks => [
        {
          http     => "http://${facts['networking']['fqdn']}:8200",
          interval => '10s'
        }
      ],
      port   => 8200,
      tags   => $sd_service_tags,
    }
  }
}
