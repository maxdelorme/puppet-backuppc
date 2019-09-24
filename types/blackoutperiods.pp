# Blackout Periods
# @summary
#   Perios in which backups do not take place.
#
# @note
#   One or more blackout periods can be specified. If a client is subject to
#   blackout then no regular (non-manual) backups will be started during any of
#   these periods.
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
