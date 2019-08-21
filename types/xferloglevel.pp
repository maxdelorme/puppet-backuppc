# Xfer Log Level
# @summary Level of verbosity in Xfer log files.
# 0 means be quiet, 1 will give will give one line per file, 2 will also show skipped files
# on incrementals, higher values give more output.
type Backuppc::XferLogLevel = Integer[0,2]
