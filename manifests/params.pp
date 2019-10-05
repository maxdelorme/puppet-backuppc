# @summary
#   Used as a vehicle to pick up OS specific defaults and common parameters
#   across client and server.
#
# @param package
#   The name of the backuppc package.
#
# @param service
#   The name of the backuppc service.
#
# @param system_account
#   Name of the user that will be created to allow backuppc
#   access to the system via ssh. This only applies to xfer
#   methods that require it. To override this set the system_account
#   to an empty string and configure access to the client yourself as
#   the default in the global config file (root) or change the
#   rsync_client_cmd or tar_client_cmd to suit your setup.
#
# @param system_home_directory
#   Absolute path to the home directory of the system account.
#
# @param config_directory
#   The location of the backuppc configuration
#
# @param topdir
#   he backuppc data directory, below which all the BackupPC data is stored.
#   This needs to have enough capacity for your backups.
#
# @param config
#   The name of the main configuration file. This sets the defaults for all
#   hosts/clients.
#
# @param hosts
#   The name of the hosts file. This contains the list of clients to backup.
#
# @param install_directory
#   Install location for BackupPC scripts, libraries and documentation.
#
# @param cgi_directory
#   Location for BackupPC CGI script. This will usually be below Apache's
#   cgi-bin directory.
#
# @param cgi_image_dir
#   The directory where BackupPC's images are stored so that Apache can serve
#   them. You should ensure this directory is readable by Apache and create a
#   symlink to this directory from the BackupPC CGI bin Directory.
#
# @param cgi_image_dir_url
#   URL (without the leading http://host) for BackupPC's image directory. The
#   CGI script uses this value to serve up image files.
#
# @param log_directory
#   Location for log files.
#
# @param config_apache
#   The file where the backuppc specifc config for apache is stored.
#
# @param group_apache
#   BackupPC config files are set to this group.
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
# @param preseed_file
#   The location for the preseed file to support BackupPC installation by
#   providing preset answers.
#
class backuppc::params (
# Common to both client and server
  Optional[String] $system_account              = 'backup',
  Stdlib::Absolutepath $system_home_directory   = '/var/backups',
# OS specific
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
  Optional[Hash] $preseed_file                  = {
    '/var/cache/debconf/backuppc.seeds' => {
      ensure => 'present',
      content => "template('backuppc/Debian-preeseed.erb')"
    }
  }
) {
}
