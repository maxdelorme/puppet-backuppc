# @summary
#   Params class for backuppc used as a vehicle to pick up OS specific
#   defaults from hiera. The defaults in this class are suitable for Debian
#   systems.
#
# @param package
#   The name of the backuppc package.
#
# @param service
#   The name of the backuppc service.
#
# @param config_directory
#   The location of the backuppc configuration
#
# @param topdir
#   TODO
#
# @param config
#   The name of the main configuration file. This sets the defaults for all hosts/clients.
#
# @param hosts
#   The name of the main configuration file. This sets the defaults for all hosts/clients.
#
# @param install_directory
#   TODO
#
# @param cgi_directory
#   TODO
#
# @param cgi_image_dir
#   TODO
#
# @param cgi_image_dir_url
#   TODO
#
# @param log_directory
#   TODO
#
# @param config_apache
#   The file where the backuppc specifc config for apache is stored.
#
# @param group_apache
#   TODO
#
# @param par_path
#   Path to par executable
#
# @param gzip_path
#   Path to gzip executable
#
# @param bzip2_path
#   Path to bzip2 executable
#
# @param tar_path
#   Path to tar executable
#
class backuppc::params (
  String[1] $package                            = 'backuppc',
  String[1] $service                            = 'backuppc',
  Stdlib::Absolutepath $config_directory        = '/etc/backuppc',
  Stdlib::Absolutepath $topdir                  = '/var/lib/backuppc',
  Stdlib::Absolutepath $config                  = "${backuppc::params::config_directory}/config.pl",
  Stdlib::Absolutepath $hosts                   = "${backuppc::params::config_directory}/hosts",
  Stdlib::Absolutepath $install_directory       = '/usr/share/backuppc',
  Stdlib::Absolutepath $cgi_directory           = "${backuppc::params::install_directory}/cgi-bin",
  Stdlib::Absolutepath $cgi_image_dir           = "${backuppc::params::install_directory}/image",
  Stdlib::Absolutepath $cgi_image_dir_url       = '/backuppc/image',
  Stdlib::Absolutepath $log_directory           = "${backuppc::params::topdir}/log",
  Stdlib::Absolutepath $config_apache           = '/etc/apache2/conf.d/backuppc.conf',
  Stdlib::Absolutepath $htpasswd_apache         = "${backuppc::params::config_directory}/htpasswd",
  String[1] $group_apache                       = 'www-data',
  Stdlib::Absolutepath $bzip2_path              = '/bin/bzip2',
  Stdlib::Absolutepath $gzip_path               = '/bin/gzip',
  Stdlib::Absolutepath $tar_path                = '/bin/tar',
  Variant[Stdlib::Absolutepath,Undef] $par_path = '/usr/bin/par2',

) {
}
