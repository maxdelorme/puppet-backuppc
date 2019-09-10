# Backuop Files
# @summary
#   List of directories or files to backup. If this is defined, only these
#   directories or files will be backed up.
#   This can be set to a string, an array of strings, or, in the case of
#   multiple shares, a hash of strings or arrays.
#
type Backuppc::BackupFiles = Variant[
  Backuppc::ShareName,
  Hash[String, Backuppc::ShareName]
]
