# Hours
# @summary
#   Hours of the daya. Times are measured in hours since midnight. Can be
#   fractional if necessary (eg: 4.25 means 4:15am).
#
type Backuppc::Hours = Variant[Integer[0,23],Float[0.0,23.0]]
