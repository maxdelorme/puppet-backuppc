# Domain
# @summary
#   FQDN preceeded by @ eg `@domain.com`. Based on `Stdlib::Fqdn`.
#
type Backuppc::Domain =
  Pattern[/^@(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/]
