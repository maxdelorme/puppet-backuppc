# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org).

## Release [3.0.0]
### Summary
This is significant refresh of this module, drpping support for EOL versions of puppet and Debian.

#### Changed
- Parameter `email_destination_domain` has been renamed to `email_user_dest_domain`.
- Parameter `xfer_loglevel` has been renamed to `xfer_log_level`.
- Parameter `smb_share_username` has been renamed to `smb_share_user_name`.
- `backuppc::params` class hass been removed. Parameters are available via
  hiera or can be set in the `client` and `server` classes.
- PDK: updated to version 1.13.0

#### Added
- Debian 8 and 9 are now supported.
- Support for data-in-module pattern
- Support for parameter typing throughout
- Manifest `mod::auth_gssapi` has been added to allow the deployment of authorisation with kerberos, through GSSAPI.
- Unit testing now achieves 100% coverage.

#### Removed
- Debian 6 and 7 are no longer supported.
- Puppet 4 is no longer supported.

