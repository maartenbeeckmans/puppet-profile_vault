#
class profile_vault (
  String               $config_dir,
  String               $advertise_address,
  Boolean              $enable_ui,
  Boolean              $manage_firewall_entry,
  String               $sd_service_name,
  Array                $sd_service_tags,
  String               $version,
  Boolean              $manage_repo,
  Stdlib::Absolutepath $root_ca_file,
  Stdlib::Absolutepath $cert_file,
  Stdlib::Absolutepath $key_file,
  Stdlib::Absolutepath $certs_dir,
  Boolean              $use_puppet_certs,
  Optional[String]     $root_ca_cert,
  Optional[String]     $vault_cert,
  Optional[String]     $vault_key,
  Boolean              $unseal_cron,
  Optional[String]     $unseal_token,
  Boolean              $manage_sd_service = lookup('manage_sd_service', Boolean, first, true),
){
  file { '/root/.vault-token':
    ensure => absent,
  }

  if $manage_repo {
    include hashi_stack::repo
  }

  include profile_vault::certs

  include profile_vault::server

  if $manage_firewall_entry {
    include profile_vault::firewall
  }

}
