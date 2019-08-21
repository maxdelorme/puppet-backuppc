# Blackout Periods
# @summary Periods where scheduled backups do not take place
# One or more blackout periods can be specified. If a client is subject to blackout
# then no regular (non-manual) backups will be started during any of these periods.
# hourBegin and hourEnd specify hours from midnight and weekDays is a list of days of
# the week where 0 is Sunday, 1 is Monday etc.
# For example:
# 
# @example Specify one blackout period from 7:00am to 7:30pm local time on Mon-Fri.
#   blackout_periods => [
#        {
#            hourBegin =>  7.0,
#            hourEnd   => 19.5,
#            weekDays  => [1, 2, 3, 4, 5],
#        },
#   ];
#
#@example The blackout period can also span midnight by setting hourBegin > hourEnd, eg:
#   blackout_periods => [
#        {
#            hourBegin =>  7.0,
#            hourEnd   => 19.5,
#            weekDays  => [1, 2, 3, 4, 5],
#        },
#        {
#            hourBegin => 23,
#            hourEnd   =>  5,
#            weekDays  => [5, 6],
#        },
#   ];
# 
# This specifies one blackout period from 7:00am to 7:30pm local time on Mon-Fri, and
# a second period from 11pm to 5am on Friday and Saturday night.
type Backuppc::BlackoutPeriods = Array[
  Struct[{
    hourBegin => Numeric[0,24],
    hourEnd   => Numeric[0,24],
    weekDays  => Array[Integer[0,6]]
  }]
]
