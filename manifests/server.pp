# @summary
#   Configures the backuppc server. 
#
# @param ensure
#   Present or absent
#
# @param service_enable
#   Boolean. Will enable service at boot
#   and ensure a running service.
#
# @param wakeup_schedule
#   Times at which we wake up, check all the PCs,
#   and schedule necessary backups. Times are measured
#   in hours since midnight. Can be fractional if
#   necessary (eg: 4.25 means 4:15am).
#
# @param max_backups
#   Maximum number of simultaneous backups to run. If
#   there are no user backup requests then this is the
#   maximum number of simultaneous backups.
#
# @param cgi_admin_user_group
# @param cgi_admin_users
#   The administrative users are the union of the unix/linux
#   group $Conf{CgiAdminUserGroup} and the manual list of users,
#   separated by spaces, in $Conf{CgiAdminUsers}.
#   If you don't want a group or manual list of users set the
#   corresponding configuration setting to undef or an empty string.
#
# @param language
#
#   Language to use. See lib/BackupPC/Lang for the list of
#   supported languages, which include English (en), French (fr),
#   Spanish (es), German (de), Italian (it), Dutch (nl), Polish (pl),
#   Portuguese Brazillian (pt_br) and Chinese (zh_CH).
#   cz, de, en, es, fr, it, nl, pl, pt_br, zh_CN
#
#   Currently the Language setting applies to the CGI interface and email
#   messages sent to users. Log files and other text are still in English.
# @param cgi_url
#    URL of the BackupPC_Admin CGI script. Used for email messages.
#
# @param cgi_image_dir_url
#   URL (without the leading http://host) for BackupPC's image directory.
#   The CGI script uses this value to serve up image files.
#   Example:
#       $Conf{CgiImageDirURL} = '/BackupPC';
#
# @param cgi_date_format_mmdd
#   Date display format for CGI interface. A value of 1 uses US-style dates
#   (MM/DD), a value of 2 uses full YYYY-MM-DD format, and zero for
#   international dates (DD/MM).
#
# @param max_user_backups
#   Additional number of simultaneous backups that users
#   can run. As many as $Conf{MaxBackups} + $Conf{MaxUserBackups}
#   requests can run at the same time.
#
# @param max_pending_cmds
#   Maximum number of pending link commands. New backups will only
#   be started if there are no more than $Conf{MaxPendingCmds} plus
#   $Conf{MaxBackups} number of pending link commands, plus running
#   jobs. This limit is to make sure BackupPC doesn't fall too far
#   behind in running BackupPC_link commands.
#
# @param max_backuppc_nightly_jobs
#   How many BackupPC_nightly processes to run in parallel. Each night,
#   at the first wakeup listed in $Conf{WakeupSchedule}, BackupPC_nightly
#   is run. Its job is to remove unneeded files in the pool, ie: files that
#   only have one link. To avoid race conditions, BackupPC_nightly and
#   BackupPC_link cannot run at the same time. Starting in v3.0.0,
#   BackupPC_nightly can run concurrently with backups (BackupPC_dump).
#
# @param backuppc_nightly_period
#   How many days (runs) it takes BackupPC_nightly to traverse the entire
#   pool. Normally this is 1, which means every night it runs, it does
#   traverse the entire pool removing unused pool files.
#
# @param max_old_log_files
#   Maximum number of log files we keep around in log directory. These files are
#   aged nightly. A setting of 14 means the log directory will contain about 2
#   weeks of old log files, in particular at most the files LOG, LOG.0, LOG.1,
#   ... LOG.13 (except today's LOG, these files will have a .z extension if
#   compression is on).
#
# @param df_max_usage_pct
#   Maximum threshold for disk utilization on the __TOPDIR__ filesystem. If the
#   output from $Conf{DfPath} reports a percentage larger than this number then
#   no new regularly scheduled backups will be run. However, user requested
#   backups (which are usually incremental and tend to be small) are still
#   performed, independent of disk usage. Also, currently running backups will
#   not be terminated when the disk usage exceeds this number.
#
# @param trash_clean_sleep_sec
#   How long BackupPC_trashClean sleeps in seconds between each check of the
#   trash directory.
#
# @param dhcp_address_ranges
#   List of DHCP address ranges we search looking for PCs to backup. This is an
#   array of hashes for each class C address range. This is only needed if hosts
#   in the conf/hosts file have the dhcp flag set.
#
# @param full_period
#   Minimum period in days between full backups. A full dump will only be done
#   if at least this much time has elapsed since the last full dump, and at
#   least $Conf{IncrPeriod} days has elapsed since the last successful dump.
#
# @param full_keep_cnt
#   Number of full backups to keep.
#
# @param full_age_max
#   Very old full backups are removed after $Conf{FullAgeMax} days. However, we
#   keep at least $Conf{FullKeepCntMin} full backups no matter how old they are.
#
# @param incr_period
#   Minimum period in days between incremental backups (a user requested
#   incremental backup will be done anytime on demand).
#
# @param incr_keep_cnt
#   Number of incremental backups to keep.
#
# @param incr_age_max
#   Very old incremental backups are removed after $Conf{IncrAgeMax} days.
#   However, we keep at least $Conf{IncrKeepCntMin} incremental backups no
#   matter how old they are.
#
# @param incr_levels
#   A full backup has level 0. A new incremental of level N will backup all files
#   that have changed since the most recent backup of a lower level.
#
# @param partial_age_max
#   A failed full backup is saved as a partial backup. The rsync XferMethod can
#   take advantage of the partial full when the next backup is run. This
#   parameter sets the age of the partial full in days: if the partial backup is
#   older than this number of days, then rsync will ignore (not use) the partial
#   full when the next backup is run. If you set this to a negative value then
#   no partials will be saved. If you set this to 0, partials will be saved, but
#   will not be used by the next backup.
#
# @param incr_fill
#   Boolean. Whether incremental backups are filled. "Filling" means that the
#   most recent fulli (or filled) dump is merged into the new incremental dump
#   using hardlinks. This makes an incremental dump look like a full dump.
#
# @param restore_info_keep_cnt
#   Number of restore logs to keep. BackupPC remembers information about each
#   restore request. This number per client will be kept around before the
#   oldest ones are pruned.
#
# @param archive_info_keep_cnt
#   Number of archive logs to keep. BackupPC remembers information about each
#   archive request.  This number per archive client will be kept around before
#   the oldest ones are pruned.
#
# @param blackout_good_cnt
#   PCs that are always or often on the network can be backed up after hours, to
#   reduce PC, network and server load during working hours. For each PC a count
#   of consecutive good pings is maintained. Once a PC has at least
#   $Conf{BlackoutGoodCnt} consecutive good pings it is subject to "blackout"
#   and not backed up during hours and days specified by $Conf{BlackoutPeriods}.
#
# @param blackout_periods
#   TODO
#
# @param backup_zero_files_is_fatal
#   Boolean. A backup of a share that has zero files is considered fatal. This
#   is used to catch miscellaneous Xfer errors that result in no files being
#   backed up. If you have shares that might be empty (and therefore an empty
#   backup is valid) you should set this to false.
#
# @param email_notify_min_days
#   Minimum period between consecutive emails to a single user. This tries to
#   keep annoying email to users to a reasonable level.
#
# @param email_from_user_name
#   Name to use as the "from" name for email.
#
# @param email_admin_user_name
#   Destination address to an administrative user who will receive a nightly
#   email with warnings and errors.
#
# @param email_user_dest_domain
#   Destination domain name for email sent to users.
#
# @param email_notify_old_backup_days
#   How old the most recent backup has to be before notifying user. When there
#   have been no backups in this number of days the user is sent an email.
#
# @param email_headers
#   Additional email headers.
#
# @param apache_configuration
#   Boolean. Whether to install the apache configuration file that creates an
#   alias for the /backuppc url.  Disable this if you intend to install backuppc
#   as a virtual host yourself.
#
# @param apache_allow_from
#   A space seperated list of hostnames, ip addresses and networks that are
#   permitted to access the backuppc interface.
#
# @param apache_require_ssl
#   This directive forbids access unless HTTP over SSL (i.e. HTTPS) is used.
#   Relies on mod_ssl.
#
# @param backuppc_password
#   Password for the backuppc user used to access the web interface.
#
# @param user_cmd_check_status
#    Whether the exit status of each PreUserCmd and PostUserCmd is checked.  If
#    set and the Dump/Restore/Archive Pre/Post UserCmd returns a non-zero exit
#    status then the dump/restore/archive is aborted. To maintain backward
#    compatibility (where the exit status in early versions was always ignored),
#    this flag defaults to 0.  If this flag is set and the Dump/Restore/Archive
#    PreUserCmd fails then the matching Dump/Restore/Archive PostUserCmd is not
#    executed. If DumpPreShareCmd returns a non-exit status, then
#    DumpPostShareCmd is not executed, but the DumpPostUserCmd is still run
#    (since DumpPreUserCmd must have previously succeeded).  An example of a
#    DumpPreUserCmd that might fail is a script that snapshots or dumps a
#    database which fails because of some database error.
#
# @param topdir
#   Overwrite package default location for backuppc.
#
# @param ping_max_msec
#   Maximum RTT value (in ms) above which backup won't be started. Default to
#   20ms
#

class backuppc::server (
  Enum['present','absent'] $ensure                          = 'present',
  Boolean $service_enable                                   = true,
  Array[Integer[0,24]] $wakeup_schedule = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
  Integer $max_backups                                      = 4,
  Integer $max_user_backups                                 = 4,
  String $language                                          = 'en',
  Integer $max_pending_cmds                                 = 15,
  Integer $max_backuppc_nightly_jobs                        = 2,
  Integer $backuppc_nightly_period                          = 1,
  Integer $max_old_log_files                                = 14,
  Integer $df_max_usage_pct                                 = 95,
  Integer $trash_clean_sleep_sec                            = 300,
  Optional[Backuppc::DhcpAddressRange] $dhcp_address_ranges = [],
  Numeric $full_period                                      = 6.97,
  Array[Integer] $full_keep_cnt                             = [1],
  Integer $full_age_max                                     = 90,
  Numeric $incr_period                                      = 0.97,
  Integer $incr_keep_cnt                                    = 6,
  Integer $incr_age_max                                     = 30,
  Array[Integer] $incr_levels                               = [1],
  Boolean $incr_fill                                        = false,
  Integer $partial_age_max                                  = 3,
  Integer $restore_info_keep_cnt                            = 10,
  Integer $archive_info_keep_cnt                            = 10,
  Integer $blackout_good_cnt                                = 7,
  Stdlib::HTTPUrl $cgi_url                                  = "http://${facts['networking']['fqdn']}/backuppc/index.cgi",
  Backuppc::BlackoutPeriods $blackout_periods               = [ { hourBegin =>  7.0,
                                                                  hourEnd   => 19.5,
                                                                  weekDays  => [1, 2, 3, 4, 5],
                                                              }, ],
  Boolean $backup_zero_files_is_fatal                       = true,
  Numeric $email_notify_min_days                            = 2.5,
  String $email_from_user_name                              = 'backuppc',
  String $email_admin_user_name                             = 'backuppc',
  Optional[Stdlib::Fqdn] $email_user_dest_domain            = undef,
  Integer $email_notify_old_backup_days                     = 7,
  Hash $email_headers = { 'MIME-Version' => 1.0, 'Content-Type' => 'text/plain; charset="iso-8859-1"', },
  Boolean $apache_configuration                             = true,
  String $apache_allow_from                                 = 'all',
  Boolean $apache_require_ssl                               = false,
  String $backuppc_password                                 = '',
  Stdlib::Absolutepath $topdir                              = $backuppc::params::topdir,
  Stdlib::Absolutepath $cgi_image_dir_url                   = $backuppc::params::cgi_image_dir_url,
  String $cgi_admin_users                                   = 'backuppc',
  String $cgi_admin_user_group                              = 'backuppc',
  Integer[0,2] $cgi_date_format_mmdd                        = 1,
  Boolean $user_cmd_check_status                            = true,
  Integer $ping_max_msec                                    = 20,
  Stdlib::Absolutepath $system_home_directory               = '/var/backups'
) inherits backuppc::params  {

  if empty($backuppc_password) {
    fail('Please provide a password for the backuppc user. This is used to login to the web based administration site.')
  }

  # TODO - these may not be needed
  $real_incr_fill = bool2num($incr_fill)
  $real_bzfif     = bool2num($backup_zero_files_is_fatal)
  $real_uccs      = bool2num($user_cmd_check_status)

  $real_topdir = $topdir ? {
    ''      => $backuppc::params::topdir,
    default => $topdir,
  }

  $directory_ensure = $ensure ? {
    'present' => 'directory',
    default => 'absent',
  }

  # On Debian, adapt log_directory to $topdir value
  $real_log_directory = $facts['os']['family'] ? {
    'Debian' => "${topdir}/log",
    default  => $backuppc::params::log_directory,
  }

  # If topdir is changed, create a symlink between "default" topdir and the custom
  # This permit "facter/backuppc_pubkey_rsa" to work properly.
  if $real_topdir != $backuppc::params::topdir {
    file { $backuppc::params::topdir:
      ensure => link,
      target => $real_topdir,
    }
  }

  # Set up dependencies
  Package['backuppc'] -> File['config.pl'] -> Service['backuppc']


  # TODO move this to hiera
  # Include preseeding for debian packages
  if $facts['os']['family'] == 'Debian' {
    file { '/var/cache/debconf/backuppc.seeds':
      ensure => $ensure,
      source => 'puppet:///modules/backuppc/backuppc.preseed',
    }
  }

  # BackupPC package and service configuration
  package { 'backuppc':
    ensure => $ensure,
    name   => $backuppc::params::package,
  }

  service { 'backuppc':
    ensure    => $service_enable,
    name      => $backuppc::params::service,
    enable    => $service_enable,
    hasstatus => true,
    pattern   => 'BackupPC'
  }

  file { 'config.pl':
    ensure  => $ensure,
    path    => $backuppc::params::config,
    owner   => 'backuppc',
    group   => $backuppc::params::group_apache,
    mode    => '0640',
    content => template('backuppc/config.pl.erb'),
    notify  => Service['backuppc']
  }

  file { 'config_directory':
    ensure  => $directory_ensure,
    path    => $backuppc::params::config_directory,
    owner   => 'backuppc',
    group   => $backuppc::params::group_apache,
    require => Package['backuppc'],
  }

  file { 'pc_directory_symlink':
    ensure  => link,
    path    => "${backuppc::params::config_directory}/pc",
    target  => $backuppc::params::config_directory,
    require => Package['backuppc'],
  }

  $topdir_defaults = {
    ensure  => $directory_ensure,
    owner   => 'backuppc',
    group   => $backuppc::params::group_apache,
    mode    => '0640',
    require => Package['backuppc'],
  }

  file {
    default:
      * => $topdir_defaults,;

    'topdir':
      path   => $real_topdir,
      ignore => 'BackupPC.sock',;

    'topdir_ssh':
      path => "${real_topdir}/.ssh",;
  }

  # Workaround for client exported resources that are
  # on a different osfamily. Maintain a symlink to alternative
  # config directory targets.
  case $facts['os']['family'] {
    'Debian': {
      file { '/etc/BackupPC':
        ensure => link,
        target => $backuppc::params::config_directory,
      }
    }
    'RedHat': {
      file { '/etc/backuppc':
        ensure => link,
        target => $backuppc::params::config_directory,
      }
    }
    default: {
      notify { "If you've added support for ${facts['os']['name']} you'll need to extend this case statement to.":
      }
    }
  }

  exec { 'backuppc-ssh-keygen':
    command => "ssh-keygen -f ${real_topdir}/.ssh/id_rsa -C 'BackupPC on ${facts['networking']['fqdn']}' -N ''",
    user    => 'backuppc',
    unless  => "test -f ${real_topdir}/.ssh/id_rsa",
    path    => ['/usr/bin','/bin'],
    require => [
      Package['backuppc'],
      File["${real_topdir}/.ssh"],
    ],
  }

  # BackupPC apache configuration
  if $apache_configuration {
    file { 'apache_config':
      ensure  => $ensure,
      path    => $backuppc::params::config_apache,
      content => template("backuppc/apache_${facts['os']['family']}.erb"),
      require => Package['backuppc'],
    }

    # Create the default admin account
    backuppc::server::user { 'backuppc':
      password => $backuppc_password
    }
  }

  # Export backuppc's authorized key to all clients
  # TODO don't rely on facter to obtain the ssh key.
  if $facts['backuppc_pubkey_rsa'] != undef {
    @@ssh_authorized_key { "backuppc_${facts['networking']['fqdn']}":
      ensure  => present,
      key     => $facts['backuppc_pubkey_rsa'],
      name    => "backuppc_${facts['networking']['fqdn']}",
      user    => 'backup',
      options => [
        "command=\"${system_home_directory}/backuppc.sh\"",
        'no-agent-forwarding',
        'no-port-forwarding',
        'no-pty',
        'no-X11-forwarding',
      ],
      type    => 'ssh-rsa',
      tag     => "backuppc_${facts['networking']['fqdn']}",
    }
  }

  # Hosts
  File <<| tag == "backuppc_config_${facts['networking']['fqdn']}" |>> {
    group   => $backuppc::params::group_apache,
    notify  => Service['backuppc'],
    require => File['pc_directory_symlink'],
  }

  Augeas <<| tag == "backuppc_hosts_${facts['networking']['fqdn']}" |>> {
    notify  => Service['backuppc'],
    require => Package['backuppc'],
  }

  Sshkey <<| tag == "backuppc_sshkeys_${facts['networking']['fqdn']}" |>>
}

# vim: sw=2:ai:nu expandtab
