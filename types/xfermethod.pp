# Numeric user ID.
# @summary What transport method to use to backup each host.
# If you have a mixed set of WinXX and linux/unix hosts you will need to override this
# in the per-PC config.pl.
#
# The valid values are:
#
#  - 'smb':     backup and restore via smbclient and the SMB protocol.
#               Easiest choice for WinXX.
#
#  - 'rsync':   backup and restore via rsync (via rsh or ssh).
#               Best choice for linux/unix.  Good choice also for WinXX.
#
#  - 'rsyncd':  backup and restore via rsync daemon on the client.
#               Best choice for linux/unix if you have rsyncd running on
#               the client.  Good choice also for WinXX.
#
#  - 'tar':    backup and restore via tar, tar over ssh, rsh or nfs.
#              Good choice for linux/unix.
#
type Backuppc::XferMethod = Enum['smb','rsync','rsyncd','tar']
