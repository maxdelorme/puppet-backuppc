# DHCP Address Range
# @summary
#   List of DHCP address ranges we search looking for PCs to backup.
#
# @note 
#   This is only needed if hosts in the conf/hosts file have the dhcp flag set.
#
# @param ipAddressBase
#   Type C address range for the pool
#
# @param first
#   First in range
#
# @param last
#   Last in range
#
# @example Specify 192.10.10.20 to 192.10.10.250 as the DHCP address pool
#   dhcp_address_ranges => [
#       {
#           ipAddrBase => '192.10.10',
#           first => 20,
#           last  => 250,
#       },
#   ];
# @example Specify two pools (192.10.10.20-250 and 192.10.11.10-50)
#   dhcp_address_ranges => [
#       {
#           ipAddrBase => '192.10.10',
#           first => 20,
#           last  => 250,
#       },
#       {
#           ipAddrBase => '192.10.11',
#           first => 10,
#           last  => 50,
#       },
#   ];
type Backuppc::DhcpAddressRange = Array[
  Struct[{
    ipAddressBase => Pattern[/\A([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])){2}\z/],
    first => Integer[0,255],
    last => Integer[0,255]
  }]
]
