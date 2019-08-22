# @summary
#   Params class for backuppc used as a vehicle to pick up OS specific
#   defaults from hiera
#
# @param package
#
# @param service
#
# @param config_apache
#
# @param topdir
#
# @param config_directory
#
# @param config
#
# @param hosts
#
# @param install_directory
#
# @param cgi_directory
#
# @param cgi_image_dir
#
# @param cgi_image_dir_url
#
# @param log_directory
#
# @param group_apache
#
# @param par_path
#
# @param gzip_path
#
# @param bzip2_path
#
# @param tar_path
#
class backuppc::params (
  String[1] $package                      = 'backuppc',
  String[1] $service                      = 'backuppc',
  String[1] $group_apache                 = 'www-data',
  Stdlib::Absolutepath $install_directory = '/usr/share/backuppc',
  Stdlib::Absolutepath $cgi_directory     = "%{backuppc::server::install_directory}/cgi-bin",
  Stdlib::Absolutepath $cgi_image_dir     = "%{backuppc::server::install_directory}/image",
  Stdlib::Absolutepath $cgi_image_dir_url = '/backuppc/image',
  Stdlib::Absolutepath $config_apache     = '/etc/apache2/conf.d/backuppc.conf',
  Stdlib::Absolutepath $config            = "%{backuppc::config_directory}/config.pl",
  Stdlib::Absolutepath $hosts             = "%{backuppc::config_directory}/hosts",
  Stdlib::Absolutepath $log_directory     = '/var/lib/backuppc/log',
  Stdlib::Absolutepath $par_path          = '/usr/bin/par2',
  Stdlib::Absolutepath $topdir            = '/var/lib/backuppc',
  Stdlib::Absolutepath $config_directory  = '/etc/backuppc',
) {
}
