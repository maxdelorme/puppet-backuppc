# @summary Configures a host for backup with the backuppc server.
#   Uses storedconfigs to provide the backuppc server with
#   required information.
#
# @param backups_disable
#   Disable all full and incremental backups. These settings are useful
#   for a client that is no longer being backed up (eg: a retired machine),
#   but you wish to keep the last backups available for browsing or
#   restoring to other machines.
#
# @param config_name
#   Name of the this host used for the configuration file.
#
# @param ensure
#   Default for creation of files by this class
#
# @param manage_sudo
#   Set to true to configure and install sudo and the sudoers.d directory.
#   Defaults to false and is only applied if 1) xfer_method requires ssh access
#   and 2) you're using the system_account parameter.
#
# @param manage_rsync
#   sSet to true to install the rsync package. If you manage this elsewhere set
#   it to false. Defaults to true and is only applied if 1) the xfer_method is
#   rsync and 2) you're using the system_account parameter.
#
# @param manage_sshkey
#   Set to true to create the sshkey for the client.
#
# @param rsyncd_auth_required
#   Whether authentication is mandatory when connecting to the client's
#   rsyncd. By default this is on, ensuring that BackupPC will refuse to
#   connect to an rsyncd on the client that is not password protected.
#
# @param xfer_method
#   What transport method to use to backup each host.
#
# @param xfer_log_level
#   Level of verbosity in Xfer log files. 0 means be quiet, 1 will give will
#   give one line per file, 2 will also show skipped files on incrementals,
#   higher values give more output.
#
# @param backup_files_exclude
#   List of directories or files to exclude from the backup. For
#   xfer_method smb, only one of backup_files_exclude and backup_files_only
#   can be specified per share.  If both are set for a particular share,
#   then backup_files_only takes precedence and backup_files_exclude is
#   ignored.
#
# @param backup_files_only
#   List of directories or files to backup. If this is defined, only these
#   directories or files will be backed up.
#
# @param backuppc_hostname
#   The name of the backuppc server. This is marked as optional as there is no
#   default, but is mandatory to be set by the caller of this class.
#
# @param blackout_bad_ping_limit
#   To allow for periodic rebooting of a PC or other brief periods when a
#   PC is not on the network, a number of consecutive bad pings is allowed
#   before the good ping count is reset.
#
# @param blackout_good_cnt
#   PCs that are always or often on the network can be backed up after hours, to
#   reduce PC, network and server load during working hours. For each PC a count
#   of consecutive good pings is maintained. Once a PC has at least
#   $Conf{BlackoutGoodCnt} consecutive good pings it is subject to "blackout"
#   and not backed up during hours and days specified by $Conf{BlackoutPeriods}.
#
# @param blackout_periods
#   One or more blackout periods can be specified. If a client is subject
#   to blackout then no regular (non-manual) backups will be started
#   during any of these periods. hourBegin and hourEnd specify hours fro
#   midnight and weekDays is a list of days of the week where 0 is Sunday,
#   1 is Monday etc.
#
#   To specify one blackout period from 7:00am to 7:30pm local time on Mon-Fri.
#        $Conf{BlackoutPeriods} = [
#           {
#              hourBegin =>  7.0,
#              hourEnd   => 19.5,
#              weekDays  => [1, 2, 3, 4, 5],
#           },
#        ];
#
# @param client_name_alias
#   Override the client's host name. This allows multiple clients to all
#   refer to the same physical host. This should only be set in the per-PC
#   config file and is only used by BackupPC at the last moment prior to
#   generating the command used to backup that machine (ie: the value of
#   `$Conf{ClientNameAlias}` is invisible everywhere else in BackupPC). 
#   The setting can be a host name or IP address. eg.
#         backuppc::client::client_name_alias: 'realHostName',
#         backuppc::client::client_name_alias: '192.1.1.15',
#   will cause the relevant smb/tar/rsync backup/restore commands
#   to be directed to realHostName, not the client name.
#   Note: this setting doesn't work for hosts with DHCP set to 1.
#
# @param dump_post_share_cmd
#   Optional command to run after a dump of a share.
#
# @param dump_post_user_cmd
#   Optional command to run after a dump.
#
# @param dump_pre_share_cmd
#   Optional command to run before a dump of a share.
#
# @param dump_pre_user_cmd
#   Optional command to run before a dump.
#
# @param email_admin_user_name
#   Destination address to an administrative user who will receive a nightly
#   email with warnings and errors.
#
# @param email_from_user_name
#   Name to use as the "from" name for email.
#
# @param email_notify_min_days
#   Minimum period between consecutive emails to a single user. This tries to
#   keep annoying email to users to a reasonable level.
#
# @param email_user_dest_domain
#   Destination domain name for email sent to users.
#
# @param full_age_max
#   Very old full backups are removed after $Conf{FullAgeMax} days. However, we
#   keep at least $Conf{FullKeepCntMin} full backups no matter how old they are.
#
# @param full_keep_cnt
#   Number of full backups to keep.
#
# @param full_period
#   Minimum period in days between full backups. A full dump will only be done
#   if at least this much time has elapsed since the last full dump, and at
#   least $Conf{IncrPeriod} days has elapsed since the last successful dump.
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
#   users will not be sent email about this host. Comma seperated list.
#
# @param hosts_file_user
#   Default user to use in the backuppc hosts file.
#
# @param incr_age_max
#   Very old incremental backups are removed after $Conf{IncrAgeMax} days.
#   However, we keep at least $Conf{IncrKeepCntMin} incremental backups no
#   matter how old they are.
#
# @param incr_fill
#   Boolean. Whether incremental backups are filled. "Filling" means that the
#   most recent fulli (or filled) dump is merged into the new incremental dump
#   using hardlinks. This makes an incremental dump look like a full dump.
#
# @param incr_keep_cnt
#   Number of incremental backups to keep.
#
# @param incr_levels
#   A full backup has level 0. A new incremental of level N will backup all files
#   that have changed since the most recent backup of a lower level.
#
# @param incr_period
#   Minimum period in days between incremental backups (a user requested
#   incremental backup will be done anytime on demand).
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
# @param ping_cmd
#   Ping command. The following variables are substituted at run-time:
#        $pingPath      path to ping ($Conf{PingPath})
#        $host          host name
#   Wade Brown reports that on solaris 2.6 and 2.7 `ping -s` returns the
#   wrong exit status (0 even on failure). Replace with `"ping $host 1"`,
#   which gets the correct exit status but we don't get the round-trip time.
#   Note: all Cmds are executed directly without a shell, so the prog
#   name needs to be a full path and you can't include shell syntax like
#   redirection and pipes; put that in a script if you need it.
#
# @param ping_max_msec
#   Maximum latency between backuppc server and client to schedule
#   a backup.
#
# @param restore_post_user_cmd
#   Optional command to run after a restore.
#
# @param restore_pre_user_cmd
#   Optional command to run before a restore.
#
# @param rsync_args_extra
#   Additional arguments to rsync for backup.
#
# @param rsync_args
#   Arguments to rsync for backup.
#
# @param rsync_client_cmd
#   Full command to run rsync on the client machine. The default will run
#   the rsync command as the user you specify in system_account.
#
# @param rsync_client_restore_cmd
#   Full command to run rsync for restore on the client.
#
# @param rsync_csum_cache_verify_prob
#   When rsync checksum caching is enabled (by adding the
#   `--checksum-seed=32761` option to rsync_args), the cached checksums can
#   be occasionally verified to make sure the file
#   contents matches the cached checksums.
#
# @param rsync_restore_args
#   Arguments to rsync for restore.
#
# @param rsync_share_name
#   Share name to backup. For `$Conf{XferMethod} = "rsync"` this should be a
#   file system path, eg '/' or '/home'.
#
# @param rsyncd_client_port
#   Rsync daemon port on host.
#
# @param rsyncd_passwd
#   Rsync daemon password on host.
#
# @param rsyncd_user_name
#   Rsync daemon user name on host.
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
# @param smb_share_name
#   Name of the host share that is backed up when using SMB. This can be a
#   string or an array of strings if there are multiple shares per host.
#
# @param smb_share_passwd
#   Smbclient share password. This is passed to smbclient via its PASSWD
#   environment variable.
#
# @param smb_share_user_name
#   Smbclient share user name. This is passed to smbclient's -U argument.
#
# @param sudo_prepend
#   Prepend a command to the sudo command, as run in backuppc.sh. This is
#   mostly useful for running the backup via nice or ionice, in order to
#   reduce the impact of large backups on the client.
#
# @param system_additional_commands_noexec
#   Additional sudo commands to whitelist for the system_account. This
#   is useful if you need to execute any pre dump commands on client before
#   backup.
#
# @param system_additional_commands
#   Additional sudo commands to whitelist for the system_account. This
#   is useful if you need to execute any pre dump *scripts* on client before
#   backup. Please prefer system_additional_commands_noexec if you want
#   to whitelist a single command/binary since commands specified here
#   are going to be allowed without the NOEXEC options. See man sudoers
#   for details.
#
# @param tar_client_cmd
#   Command to run tar on the client. GNU tar is required. The default
#   will run the tar command as the user you specify in system_account.
#
# @param tar_client_restore_cmd
#   Full command to run tar for restore on the client. GNU tar is required.
#
# @param tar_full_args
#   Extra tar arguments for full backups.
#
# @param tar_incr_args
#   Extra tar arguments for incr backups.
#
# @param tar_share_name
#   Which host directories to backup when using tar transport. This can be
#   a string or an array of strings if there are multiple directories to
#   backup per host.
#
# @param user_cmd_check_status
#   Whether the exit status of each PreUserCmd and PostUserCmd is checked.
#
class backuppc::client (
  Boolean $backups_disable                                   = false,
  Stdlib::Fqdn $config_name                                  = $facts['networking']['fqdn'],
  Enum['present','absent'] $ensure                           = 'present',
  Boolean $manage_rsync                                      = true,
  Boolean $manage_sshkey                                     = true,
  Boolean $manage_sudo                                       = false,
  Boolean $rsyncd_auth_required                              = false,
  Backuppc::XferLogLevel $xfer_log_level                     = 1,
  Backuppc::XferMethod $xfer_method                          = 'rsync',
  Optional[Backuppc::BackupFiles] $backup_files_exclude      = undef,
  Optional[Backuppc::BackupFiles] $backup_files_only         = undef,
  Optional[Stdlib::Fqdn] $backuppc_hostname                  = undef,
  Optional[Integer] $blackout_bad_ping_limit                 = undef,
  Optional[Integer] $blackout_good_cnt                       = undef,
  Optional[Backuppc::BlackoutPeriods] $blackout_periods      = undef,
  Optional[Stdlib::Fqdn] $client_name_alias                  = undef,
  Optional[String] $dump_post_share_cmd                      = undef,
  Optional[String] $dump_post_user_cmd                       = undef,
  Optional[String] $dump_pre_share_cmd                       = undef,
  Optional[String] $dump_pre_user_cmd                        = undef,
  Optional[String] $email_admin_user_name                    = undef,
  Optional[String] $email_from_user_name                     = undef,
  Optional[Integer] $email_notify_min_days                   = undef,
  Optional[Integer] $email_notify_old_backup_days            = undef,
  Optional[Backuppc::Domain] $email_user_dest_domain         = undef,
  Optional[Integer] $full_age_max                            = undef,
  Optional[Variant[Integer,Array[Integer]]] $full_keep_cnt   = undef,
  Optional[Numeric] $full_period                             = undef,
  Optional[Integer] $hosts_file_dhcp                         = 0,
  Optional[String] $hosts_file_more_users                    = undef,
  Optional[String] $hosts_file_user                          = 'backuppc',
  Optional[Integer] $incr_age_max                            = undef,
  Optional[Boolean] $incr_fill                               = undef,
  Optional[Integer] $incr_keep_cnt                           = undef,
  Optional[Array[Integer]] $incr_levels                      = undef,
  Optional[Numeric] $incr_period                             = undef,
  Optional[Integer] $partial_age_max                         = undef,
  Optional[String] $ping_cmd                                 = undef,
  Optional[Integer] $ping_max_msec                           = 20,
  Optional[String] $restore_post_user_cmd                    = undef,
  Optional[String] $restore_pre_user_cmd                     = undef,
  Optional[Array[String]] $rsync_args_extra                  = undef,
  Optional[Array[String]] $rsync_args                        = undef,
  Optional[String] $rsync_client_cmd                         = undef,
  Optional[String] $rsync_client_restore_cmd                 = undef,
  Optional[Float] $rsync_csum_cache_verify_prob              = undef,
  Optional[Integer] $rsyncd_client_port                      = undef,
  Optional[String] $rsyncd_passwd                            = undef,
  Optional[String] $rsyncd_user_name                         = undef,
  Optional[Array[String]] $rsync_restore_args                = undef,
  Optional[Backuppc::ShareName] $rsync_share_name            = undef,
  Optional[String] $smb_client_full_cmd                      = undef,
  Optional[String] $smb_client_incr_cmd                      = undef,
  Optional[String] $smb_client_restore_cmd                   = undef,
  Optional[Backuppc::ShareName] $smb_share_name              = undef,
  Optional[String] $smb_share_passwd                         = undef,
  Optional[String] $smb_share_user_name                      = undef,
  Optional[String] $sudo_prepend                             = undef,
  Optional[Array[String]] $system_additional_commands_noexec = undef,
  Optional[Array[String]] $system_additional_commands        = undef,
  Optional[String] $tar_client_cmd                           = undef,
  Optional[String] $tar_client_restore_cmd                   = undef,
  Optional[String] $tar_full_args                            = undef,
  Optional[String] $tar_incr_args                            = undef,
  Optional[Backuppc::ShareName] $tar_share_name              = undef,
  Optional[Boolean] $user_cmd_check_status                   = undef,
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
  if $user_cmd_check_status != undef {
    $real_user_cmd_check_status = bool2num($user_cmd_check_status)
  }

  # With these xfer_methods we require sudo to grant access
  # from the backuppc server to this client. It may be managed
  # elsewhere so we allow it to be overridden with the manage_sudo
  # parameter.
  if $xfer_method in ['rsync', 'tar'] and ! empty($system_account) # lint:ignore:variable_scope
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
        content => "${system_account} ALL=(ALL:ALL) NOPASSWD: ${sudo_commands}\n", # lint:ignore:variable_scope
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
      content => "${system_account} ALL=(ALL:ALL) NOEXEC:NOPASSWD: ${sudo_commands_noexec}\n", # lint:ignore:variable_scope
    }

    user { $system_account: # lint:ignore:variable_scope
      ensure     => $ensure,
      home       => $system_home_directory, # lint:ignore:variable_scope
      managehome => true,
      shell      => '/bin/bash',
      comment    => 'BackupPC',
      system     => true,
      password   => '*',
    }

    file { "${system_home_directory}/.ssh": # lint:ignore:variable_scope
      ensure => $directory_ensure,
      mode   => '0700',
      owner  => $system_account, # lint:ignore:variable_scope
      group  => $system_account, # lint:ignore:variable_scope
    }

    file { "${system_home_directory}/backuppc.sh": # lint:ignore:variable_scope
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('backuppc/client/backuppc.sh.erb'),
      require => User[$system_account], # lint:ignore:variable_scope
    }

    Ssh_authorized_key <<| tag == "backuppc_${backuppc_hostname}" |>> {
      user    => $system_account,                      # lint:ignore:variable_scope
      require => File["${system_home_directory}/.ssh"] # lint:ignore:variable_scope
    }
  }

  if $manage_sshkey {
    if $facts['networking']['fqdn'] != $backuppc_hostname {
      @@sshkey { $facts['networking']['fqdn']:
        ensure => $ensure,
        type   => 'ssh-rsa',
        key    => $facts['ssh']['rsa']['key'],
        tag    => "backuppc_sshkeys_${backuppc_hostname}",
      }
    }
  }

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
