# Blackout Periods
# @summary
#   Periods where scheduled backups do not take place.  One or more blackout
#   periods can be specified. If a client is subject to blackout then no regular
#   (non-manual) backups will be started during any of these periods.  hourBegin
#   and hourEnd specify hours from midnight and weekDays is a list of days of
#
# @param hourBegin
#   start of blackout period
# @param hourEnd
#   end of blackoiut period
# @param weekdays
#   days of black period
#
type Backuppc::BlackoutPeriods = Array[
  Struct[{
    hourBegin => Variant[Integer[-24,24],Float[-24.0,24.0]],
    hourEnd   => Variant[Integer[-24,24],Float[-24.0,24.0]],
    weekDays  => Array[Integer[0,6]]
  }]
]
