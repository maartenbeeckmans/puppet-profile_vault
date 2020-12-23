#
class profile_vault (
  String               $config_dir,
  String               $advertise_address,
  Boolean              $enable_ui,
  Boolean              $manage_firewall_entry,
  Boolean              $manage_sd_service,
  String               $sd_service_name,
  Array                $sd_service_tags,
  String               $version,
  Boolean              $manage_repo,
  String               $repo_gpg_key,
  Stdlib::HTTPUrl      $repo_gpg_url,
  Stdlib::HTTPUrl      $repo_url,
  Stdlib::Absolutepath $root_ca_file,
  Stdlib::Absolutepath $cert_file,
  Stdlib::Absolutepath $key_file,
  Stdlib::Absolutepath $certs_dir,
  Optional[String]     $root_ca_cert,
  Optional[String]     $vault_cert,
  Optional[String]     $vault_key,
){
  file { '/root/.vault-token':
    ensure => absent,
  }

  if $manage_repo {
    include profile_vault::repo
  }

  include profile_vault::certs

  include profile_vault::server

  if $manage_firewall_entry {
    include profile_vault::firewall
  }
}
