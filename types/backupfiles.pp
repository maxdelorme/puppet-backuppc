# Backup Files
# @summary
#   List of directories or files to backup.
#
type Backuppc::BackupFiles = Variant[
  Backuppc::ShareName,
  Hash[String, Backuppc::ShareName]
]
