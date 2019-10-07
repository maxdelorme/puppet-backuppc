# @summary
#   Used as a vehicle to define parameters which need to be the same 
#   across client and server.
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
class backuppc::common (
  Optional[String] $system_account              = 'backup',
  Stdlib::Absolutepath $system_home_directory   = '/var/backups',
) {
}
