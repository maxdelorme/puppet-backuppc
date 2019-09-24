# Blackout Periods
# @summary
#   Periods in which backups do not take place.
#
#
# @param hourBegin
#   start of blackout period (hours from midnight)
# @param hourEnd
#   end of blackout period (hours from midnight)
# @param weekdays
#   days of black period (days of the week with Sunday = 0)
#
type Backuppc::BlackoutPeriods = Array[
  Struct[{
    hourBegin => Backuppc::Hours,
    hourEnd   => Backuppc::Hours,
    weekDays  => Array[Integer[0,6]]
  }]
]
