# Backup Files
# @summary
#   List of directories or files to backup.
#
# @note
#   If this is defined, only these directories or files will be backed up.
#
type Backuppc::BackupFiles = Variant[
  Backuppc::ShareName,
  Hash[String, Backuppc::ShareName]
]
