#
#
#
class profile_vault::repo (
  String          $repo_gpg_key = $::profile_vault::repo_gpg_key,
  Stdlib::HTTPUrl $repo_gpg_url = $::profile_vault::repo_gpg_url,
  Stdlib::HTTPUrl $repo_url     = $::profile_vault::repo_url,
) {
  # Adding if not defined so it can be used together with profile_nomad and profile_Vault
  if ! defined(Apt::Source['Hashicorp']) {
    apt::source { 'Hashicorp':
      location => $repo_url,
      repos    => 'main',
      key      => {
        id     => $repo_gpg_key,
        server => $repo_gpg_url,
      }
    }
  }
}
