require 'spec_helper'

describe 'backuppc::client' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:node) { 'testhost.test.com' }
      let(:file_host) { '/etc/backuppc/pc/testhost.pl' }

      context 'with OS defaults' do
        let(:default_params) do
          {
            system_account: 'backup',
            system_home_directory: '/var/backups',
            backuppc_hostname: 'backuppc.test.com',
            config_name: 'testhost',
            hosts_file_user: 'backuppc',
          }
        end

        context 'with defaults' do
          let(:params) { default_params }

          it { is_expected.to contain_class('backuppc::client') }
          it { is_expected.to compile.with_all_deps }

          # These tests relate to system_account being set
          it { is_expected.to contain_file('/var/backups/.ssh').with_ensure('directory') }
          it { is_expected.to contain_package('rsync') }
          it { is_expected.to contain_user('backup') }

          it { is_expected.to contain_file('/var/backups/backuppc.sh') }
          it { is_expected.to contain_file('/etc/sudoers.d/backuppc') }
          it { is_expected.to contain_file('/etc/sudoers.d/backuppc_noexec') }

          context 'testing exported augeas' do
            subject { exported_resources }

            it {
              is_expected.to contain_augeas('backuppc_host_testhost-create').with(
                'changes' => <<-DOC.gsub(%r{^\s+}, '')
                    set 01/host testhost
                    set 01/dhcp 0
                    set 01/user backuppc
                  DOC
              )
            }

            it {
              is_expected.to contain_augeas('backuppc_host_testhost-update').with(
                'changes' => <<-DOC.gsub(%r{^\s+}, '')
                    set *[host = 'testhost']/dhcp 0
                    set *[host = 'testhost']/user backuppc
                    rm *[host = 'testhost']/moreusers
                  DOC
              )
            }
          end

          context 'testing exported sshkey' do
            subject { exported_resources }

            it {
              is_expected.to contain_sshkey('testhost.test.com').with(
                'type' => 'ssh-rsa',
                'key'  => facts['ssh']['rsa']['key'],
                'tag'  => 'backuppc_sshkeys_backuppc.test.com',
              )
            }
          end

          context 'testing exported host config' do
            subject { exported_resources }

            config_params = {
              'xfer_log_level' => 1,
              'xfer_method' => 'rsync',
            }

            config_params.each do |tparam, tvalue|
              context "with #{tparam} = #{tvalue}" do
                let(:params) { default_params.merge(tparam => tvalue) }

                content = config_content(tparam, tvalue)
                it { is_expected.to contain_file(file_host).with_content(content) }
              end
            end
          end
        end

        context 'exported config file' do
          subject { exported_resources }

          config_params = {
            'backup_files_exclude' => 'junk',
            'backup_files_only' => '/',
            'backups_disable' => true,
            'blackout_bad_ping_limit' => 100,
            'blackout_good_cnt' => 10,
            'client_name_alias' => 'clientname',
            'dump_post_share_cmd' => '/dump/post/share/cmd',
            'dump_post_user_cmd' => '/dump/post/user/cmd',
            'dump_pre_share_cmd' => '/dump/pre/share/cmd',
            'dump_pre_user_cmd' => '/dump/pre/user/cmd',
            'email_admin_user_name' => 'username',
            'email_user_dest_domain' => '@destdomain',
            'email_from_user_name' => 'fromusername',
            'email_notify_min_days' => 99,
            'email_notify_old_backup_days' => 88,
            'full_age_max' => 90,
            'full_keep_cnt' => [4, 2, 3],
            'full_period' => 6.97,
            'incr_age_max' => 12,
            'incr_fill' => true,
            'incr_keep_cnt' => 10,
            'incr_levels' => [1, 2],
            'incr_period' => 0.97,
            'partial_age_max' => 2,
            'ping_cmd' => '/ping/cmd',
            'ping_max_msec' => 111,
            'restore_post_user_cmd' => '/restore/post/user/cmd',
            'restore_pre_user_cmd' => '/restore/pre/user/cmd',
            'rsync_args' => ['-F', '-G'],
            'rsync_args_extra' => ['-H', '-I'],
            'rsync_client_cmd' => '/rsync/client/cmd args',
            'rsync_client_restore_cmd' => '/rsync/client/restore/cmd args',
            'rsync_csum_cache_verify_prob' => 0.01,
            'rsyncd_auth_required' => true,
            'rsyncd_client_port' => 378,
            'rsyncd_passwd' => 'secret',
            'rsyncd_user_name' => 'rsyncd',
            'rsync_restore_args' => ['--exclude-from=something'],
            'rsync_share_name' => '/rsyncshare',
            'smb_share_name' => 'c',
            'smb_share_passwd' => 'smbsecret',
            'smb_share_user_name' => 'smbuser',
            'tar_client_restore_cmd' => '$sshPath -q -x -n -l root $host',
            'tar_full_args' => '--tar-full-arg',
            'tar_incr_args' => '--tar-inc-arg',
            'user_cmd_check_status' => false,
          }

          config_params.each do |tparam, tvalue|
            context "with #{tparam} = #{tvalue}" do
              let(:params) { default_params.merge(tparam => tvalue) }

              content = config_content(tparam, tvalue)
              it { is_expected.to contain_file(file_host).with_content(content) }
            end
          end
        end

        context 'exported config file with complex parameters' do
          subject { exported_resources }

          config_params = {
            'backup_files_exclude' => ['exclude1', 'exclude2'],
            'backup_files_only' => ['/'],
            'blackout_periods' => [{ 'hourBegin' => 7, 'hourEnd' => 23, 'weekDays' => [1, 2, 3, 4, 5] }],
            'smb_share_name' => ['c', 'd'],
          }
          config_params.each do |tparam, tvalue|
            context "with #{tparam} = #{tvalue}" do
              let(:params) { default_params.merge(tparam => tvalue) }

              content = config_content(tparam, tvalue)
              it { is_expected.to contain_file(file_host).with_content(content) }
            end
          end
        end

        context 'exported config file with more complex parameters' do
          context 'exported resources' do
            subject { exported_resources }

            config_params = {
              'backup_files_only' => { '*' => ['/'] },
              'backup_files_exclude' => { 'a' => 'everything', 'b' => 'nothing' },
              'blackout_periods' => [
                { 'hourBegin' => 7, 'hourEnd' => 23, 'weekDays' => [1, 2, 3, 4, 5] },
                { 'hourBegin' => 9, 'hourEnd' => 18, 'weekDays' => [0, 6] },
              ],
            }
            config_params.each do |tparam, tvalue|
              context "with #{tparam} = #{tvalue}" do
                let(:params) { default_params.merge(tparam => tvalue) }

                content = config_content(tparam, tvalue)
                it { is_expected.to contain_file(file_host).with_content(content) }
              end
            end
          end
        end
      end
    end
  end
end
