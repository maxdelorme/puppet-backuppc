# @summary Configures a host for backup with the backuppc server.
#   Uses storedconfigs to provide the backuppc server with
#   required information.
#
# @param ensure
#   Default for creation of files by this class
#
# @param config_name
#   Name of the this host used for the configuration file.
#
# @param backuppc_hostname
#   The name of the backuppc server.
#
# @param client_name_alias
#   Override the client's host name. This allows multiple clients to all
#   refer to the same physical host. This should only be set in the per-PC
#   config file and is only used by BackupPC at the last moment prior to
#   generating the command used to backup that machine (ie: the value of
#   $Conf{ClientNameAlias} is invisible everywhere else in BackupPC). 
#   he setting can be a host name or IP address. eg.
#         $Conf{ClientNameAlias} = 'realHostName';
#         $Conf{ClientNameAlias} = '192.1.1.15';
#
#   will cause the relevant smb/tar/rsync backup/restore commands
#   to be directed to realHostName, not the client name.
#   Note: this setting doesn't work for hosts with DHCP set to 1.
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
# @param system_additional_commands
#   Additional sudo commands to whitelist for the system_account. This
#   is useful if you need to execute any pre dump *scripts* on client before
#   backup. Please prefer system_additional_commands_noexec if you want
#   to whitelist a single command/binary since commands specified here
#   are going to be allowed without the NOEXEC options. See man sudoers
#   for details.
#
# @param system_additional_commands_noexec
#   Additional sudo commands to whitelist for the system_account. This
#   is useful if you need to execute any pre dump commands on client before
#   backup.
#
# @param manage_sudo
#   Boolean. Set to true to configure and install sudo and the
#   sudoers.d directory. Defaults to false and is only applied
#   if 1) xfer_method requires ssh access and 2) you're using
#   the system_account parameter.
#
# @param manage_rsync
#   Boolean. By default will install the rsync package. If you
#   manage this elsewhere set it to false. Defaults to true and
#   is only applied if 1) the xfer_method is rsync and 2) you're
#   using the system_account parameter.
#
# @param blackout_bad_ping_limit
#   To allow for periodic rebooting of a PC or other brief periods when a
#   PC is not on the network, a number of consecutive bad pings is allowed
#   before the good ping count is reset.
#
# @param blackout_periods
#   One or more blackout periods can be specified. If a client is subject
#   to blackout then no regular (non-manual) backups will be started
#   during any of these periods. hourBegin and hourEnd specify hours fro
#   midnight and weekDays is a list of days of the week where 0 is Sunday,
#   1 is Monday etc.
#   To specify one blackout period from 7:00am to 7:30pm local time on Mon-Fri.
#
#     $Conf{BlackoutPeriods} = [
#          {
#              hourBegin =>  7.0,
#              hourEnd   => 19.5,
#              weekDays  => [1, 2, 3, 4, 5],
#          },
#     ];
#
# @param ping_max_msec
#   Maximum latency between backuppc server and client to schedule
#   a backup.
#
# @param ping_cmd
#   Ping command. The following variables are substituted at run-time:
#      $pingPath      path to ping ($Conf{PingPath})
#      $host          host name
#   Wade Brown reports that on solaris 2.6 and 2.7 ping -s returns the
#   wrong exit status (0 even on failure). Replace with "ping $host 1",
#   which gets the correct exit status but we don't get the round-trip time.
#   Note: all Cmds are executed directly without a shell, so the prog
#   name needs to be a full path and you can't include shell syntax like
#   redirection and pipes; put that in a script if you need it.
#
# @param backups_disable
#   Disable all full and incremental backups. These settings are useful
#   for a client that is no longer being backed up (eg: a retired machine),
#   but you wish to keep the last backups available for browsing or
#   restoring to other machines.
#
# @param xfer_method
#   What transport method to use to backup each host.
#
# @param xfer_loglevel
#   Level of verbosity in Xfer log files. 0 means be quiet, 1 will give will
#   give one line per file, 2 will also show skipped files on incrementals,
#   higher values give more output.
#
# @param smb_share_name
#   Name of the host share that is backed up when using SMB. This can be a
#   string or an array of strings if there are multiple shares per host.
#
# @param smb_share_username
#   Smbclient share user name. This is passed to smbclient's -U argument.
#
# @param smb_share_passwd
#   Smbclient share password. This is passed to smbclient via its PASSWD
#   environment variable.
#
# @param smb_client_full_cmd
#   Command to run smbclient for a full dump.
#
# @param smb_client_incr_cmd
#   Command to run smbclient for an incremental dump.
#
# @param smb_client_restore_cmd
#   Command to run smbclient for a restore.
#
# @param tar_share_name
#   Which host directories to backup when using tar transport. This can be
#   a string or an array of strings if there are multiple directories to
#   backup per host.
#
# @param tar_client_cmd
#   Command to run tar on the client. GNU tar is required. The default
#   will run the tar command as the user you specify in system_account.
#
# @param tar_full_args
#   Extra tar arguments for full backups.
#
# @param tar_incr_args
#   Extra tar arguments for incr backups.
#
# @param tar_client_restore_cmd
#   Full command to run tar for restore on the client. GNU tar is required.
#
# @param rsync_client_cmd
#   Full command to run rsync on the client machine. The default will run
#   the rsync command as the user you specify in system_account.
#
# @param rsync_client_restore_cmd
#   Full command to run rsync for restore on the client.
#
# @param rsync_share_name
#   Share name to backup. For $Conf{XferMethod} = "rsync" this should be a
#   file system path, eg '/' or '/home'.
#
# @param rsyncd_client_port
#   Rsync daemon port on host.
#
# @param rsyncd_user_name
#   Rsync daemon user name on host.
#
# @param rsyncd_passwd
#   Rsync daemon password on host.
#
# @param rsyncd_auth_required
#   Whether authentication is mandatory when connecting to the client's
#   rsyncd. By default this is on, ensuring that BackupPC will refuse to
#   connect to an rsyncd on the client that is not password protected.
#
# @param rsync_csum_cache_verify_prob
#   When rsync checksum caching is enabled (by adding the
#   --checksum-seed=32761 option to rsync_args), the cached checksums can
#   be occasionally verified to make sure the file
#   contents matches the cached checksums.
#
# @param rsync_args
#   Arguments to rsync for backup.
#
# @param rsync_args_extra
#   Additional arguments to rsync for backup.
#
# @param rsync_restore_args
#   Arguments to rsync for restore.
#
# @param backup_files_only
#   List of directories or files to backup. If this is defined, only these
#   directories or files will be backed up.
#
# @param backup_files_exclude
#   List of directories or files to exclude from the backup. For
#   xfer_method smb, only one of backup_files_exclude and backup_files_only
#   can be specified per share.  If both are set for a particular share,
#   then backup_files_only takes precedence and backup_files_exclude is
#   ignored.
#
# @param dump_pre_user_cmd
#   Optional command to run before a dump.
#
# @param dump_post_user_cmd
#   Optional command to run after a dump.
#
# @param dump_pre_share_cmd
#   Optional command to run before a dump of a share.
#
# @param dump_post_share_cmd
#   Optional command to run after a dump of a share.
#
# @param restore_pre_user_cmd
#   Optional command to run before a restore.
#
# @param restore_post_user_cmd
#   Optional command to run after a restore.
#
# @param user_cmd_check_status
#   Whether the exit status of each PreUserCmd and PostUserCmd is checked.
#
# @param hosts_file_dhcp
#   The way hosts are discovered has changed and now in most cases you
#   should use the default of 0 for the DHCP flag, even if the host has
#   a dynamically assigned IP address.
#
# @param hosts_file_more_users
#   Additional user names, separate by commas and with no white space, can
#   be specified. These users will also have full permission in the CGI
#   interface to stop/start/browse/restore backups for this host. These
#   users will not be sent email about this host.
#
# @param sudo_prepend
#   Prepend a command to the sudo command, as run in backuppc.sh. This is
#   mostly useful for running the backup via nice or ionice, in order to
#   reduce the impact of large backups on the client.
#
class backuppc::client (
  Enum['present','absent'] $ensure                           = 'present',
  Stdlib::Fqdn $config_name                                  = $facts['networking']['fqdn'],
  Optional[Stdlib::Fqdn] $backuppc_hostname                  = undef,
  Optional[Stdlib::Fqdn] $client_name_alias                  = undef,
  Optional[String] $system_account                           = 'backup',
  Stdlib::Absolutepath $system_home_directory                = '/var/backups',
  Optional[Array[String]] $system_additional_commands        = undef,
  Optional[Array[String]] $system_additional_commands_noexec = undef,
  Boolean $manage_sudo                                       = false,
  Boolean $manage_rsync                                      = true,
  Optional[Numeric] $full_period                             = undef,
  Optional[Integer] $full_keep_cnt                           = undef,
  Optional[Integer] $full_age_max                            = undef,
  Optional[Numeric] $incr_period                             = undef,
  Optional[Integer] $incr_keep_cnt                           = undef,
  Optional[Integer] $incr_age_max                            = undef,
  Optional[Array[Integer]] $incr_levels                      = undef,
  Optional[Boolean] $incr_fill                               = undef,
  Optional[Integer] $partial_age_max                         = undef,
  Optional[Integer] $blackout_bad_ping_limit                 = undef,
  Optional[Integer] $ping_max_msec                           = 20,
  Optional[String] $ping_cmd                                 = undef,
  Optional[Integer] $blackout_good_cnt                       = undef,
  Optional[Backuppc::BlackoutPeriods] $blackout_periods      = undef,
  Boolean $backups_disable                                   = false,
  Backuppc::XferMethod $xfer_method                          = 'rsync',
  Backuppc::XferLogLevel $xfer_loglevel                      = 1,
  Optional[String] $smb_share_name                           = undef,
  Optional[String] $smb_share_username                       = undef,
  Optional[String] $smb_share_passwd                         = undef,
  Optional[String] $smb_client_full_cmd                      = undef,
  Optional[String] $smb_client_incr_cmd                      = undef,
  Optional[String] $smb_client_restore_cmd                   = undef,
  Optional[String] $tar_share_name                           = undef,
  Optional[String] $tar_client_cmd                           = undef,
  Optional[String] $tar_full_args                            = undef,
  Optional[String] $tar_incr_args                            = undef,
  Optional[String] $tar_client_restore_cmd                   = undef,
  Optional[String] $rsync_client_cmd                         = undef,
  Optional[String] $rsync_client_restore_cmd                 = undef,
  Optional[Array[String]] $rsync_share_name                  = undef,
  Optional[Integer] $rsyncd_client_port                      = undef,
  Optional[String] $rsyncd_user_name                         = undef,
  Optional[String] $rsyncd_passwd                            = undef,
  Boolean $rsyncd_auth_required                              = false,
  Optional[Integer] $rsync_csum_cache_verify_prob            = undef,
  Optional[Array[String]] $rsync_args                        = undef,
  Optional[Array[String]]$rsync_args_extra                   = undef,
  Optional[Array[String]]$rsync_restore_args                 = undef,
  Optional[Backuppc::BackupFiles] $backup_files_only         = undef,
  Optional[Backuppc::BackupFiles] $backup_files_exclude      = undef,
  Optional[String] $dump_pre_user_cmd                        = undef,
  Optional[String] $dump_post_user_cmd                       = undef,
  Optional[String] $dump_pre_share_cmd                       = undef,
  Optional[String] $dump_post_share_cmd                      = undef,
  Optional[String] $restore_pre_user_cmd                     = undef,
  Optional[String] $restore_post_user_cmd                    = undef,
  Optional[Boolean] $user_cmd_check_status                   = undef,
  Optional[Integer] $email_notify_min_days                   = undef,
  Optional[String] $email_from_user_name                     = undef,
  Optional[String] $email_admin_user_name                    = undef,
  Optional[Stdlib::Fqdn] $email_destination_domain           = undef,
  Optional[Integer] $email_notify_old_backup_days            = undef,
  Optional[Stdlib::Absolutepath] $hosts_file_dhcp            = undef,
  Optional[String] $hosts_file_user                          = 'backuppc',
  Optional[Array[String]] $hosts_file_more_users             = undef,
  Optional[String] $sudo_prepend                             = undef,
    ) inherits backuppc::params {


  $directory_ensure = $ensure ? {
    'present' => 'directory',
    default   => absent,
  }

  if empty($backuppc_hostname) {
    fail('Please provide the hostname of the node that hosts backuppc.')
  }

  $real_incr_fill = bool2num($incr_fill)
  $real_backups_disable = bool2num($backups_disable)
  $real_rsyncd_auth_required = bool2num($rsyncd_auth_required)
  $real_user_cmd_check_status = bool2num($user_cmd_check_status)

  # With these xfer_methods we require sudo to grant access
  # from the backuppc server to this client. It may be managed
  # elsewhere so we allow it to be overridden with the manage_sudo
  # parameter.
  if $xfer_method in ['rsync', 'tar'] and ! empty($system_account)
  {
  #  validate_absolute_path($system_home_directory)

    if $xfer_method == 'rsync' {
      if $manage_rsync {
        package { 'rsync':
          ensure => installed,
        }
      }
      $sudo_command_noexec = '/usr/bin/rsync'
    }
    else {
      $sudo_command_noexec = $backuppc::params::tar_path
    }

    if $manage_sudo {
      package { 'sudo':
        ensure => installed,
        before => File['/etc/sudoers.d/backuppc'],
      }
      file { '/etc/sudoers.d/':
        ensure  => directory,
        purge   => false,
        require => Package['sudo'],
      }
      file_line { 'sudo_includedir':
        ensure  => present,
        path    => '/etc/sudoers',
        line    => '#includedir /etc/sudoers.d',
        require => Package['sudo'],
      }
    }

    if ! empty($system_additional_commands) {
      $additional_sudo_commands = join($system_additional_commands, ', ')
      $sudo_commands = $additional_sudo_commands
    } else {
      $sudo_commands = undef
    }

    if ! empty($system_additional_commands_noexec) {
      $additional_sudo_commands_noexec = join($system_additional_commands_noexec, ', ')
      $sudo_commands_noexec = "${sudo_command_noexec}, ${additional_sudo_commands_noexec}"
    } else {
      $sudo_commands_noexec = $sudo_command_noexec
    }

    if ! empty($sudo_commands) {
      file { '/etc/sudoers.d/backuppc':
        ensure  => $ensure,
        owner   => 'root',
        group   => 'root',
        mode    => '0440',
        content => "${system_account} ALL=(ALL:ALL) NOPASSWD: ${sudo_commands}\n",
      }
    } else {
      file { '/etc/sudoers.d/backuppc':
        ensure  => 'absent',
      }
    }

    file { '/etc/sudoers.d/backuppc_noexec':
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content => "${system_account} ALL=(ALL:ALL) NOEXEC:NOPASSWD: ${sudo_commands_noexec}\n",
    }

    user { $system_account:
      ensure     => $ensure,
      home       => $system_home_directory,
      managehome => true,
      shell      => '/bin/bash',
      comment    => 'BackupPC',
      system     => true,
      password   => '*',
    }

    file { "${system_home_directory}/.ssh":
      ensure => $directory_ensure,
      mode   => '0700',
      owner  => $system_account,
      group  => $system_account,
    }

    file { "${system_home_directory}/backuppc.sh":
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('backuppc/client/backuppc.sh.erb'),
      require => User[$system_account],
    }

    Ssh_authorized_key <<| tag == "backuppc_${backuppc_hostname}" |>> {
      user    => $system_account,
      require => File["${system_home_directory}/.ssh"]
    }
  }

#  if $facts['networking']['fqdn'] != $backuppc_hostname {
#    @@sshkey { $facts['networking']['fqdn']:
#      ensure => $ensure,
#      type   => 'ssh-rsa',
#      key    => $facts['ssh']['rsa']['key'],
#      tag    => "backuppc_sshkeys_${backuppc_hostname}",
#    }
#  }

  if $ensure == 'present' {
    @@augeas { "backuppc_host_${config_name}-create":
      context => '/files/etc/backuppc/hosts',
      changes => template("${module_name}/host-augeas-create.erb"),
      lens    => 'BackupPCHosts.lns',
      incl    => '/etc/backuppc/hosts',
      onlyif  => "match *[host = '${config_name}'] size == 0",
      before  => Augeas["backuppc_host_${config_name}-update"],
      tag     => "backuppc_hosts_${backuppc_hostname}",
    }
    @@augeas { "backuppc_host_${config_name}-update":
      context => '/files/etc/backuppc/hosts',
      changes => template("${module_name}/host-augeas-update.erb"),
      lens    => 'BackupPCHosts.lns',
      incl    => '/etc/backuppc/hosts',
      onlyif  => "match *[host = '${config_name}'] size > 0",
      tag     => "backuppc_hosts_${backuppc_hostname}",
    }
  }

  @@file { "${backuppc::params::config_directory}/pc/${config_name}.pl":
    ensure  => $ensure,
    content => template("${module_name}/host.pl.erb"),
    owner   => 'backuppc',
    group   => $backuppc::params::group_apache,
    mode    => '0640',
    tag     => "backuppc_config_${backuppc_hostname}"
  }
}

# vim: sw=2:ai:nu expandtab
