require 'spec_helper'

describe 'backuppc::client' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:file_host) do
        case facts[:os]['family']
        when 'RedHat'
          '/etc/BackupPC/pc/testhost.pl'
        when 'Debian'
          '/etc/backuppc/pc/testhost.pl'
        end
      end

      default_params = {
        'backuppc_hostname' => 'backuppc.test.com',
        'config_name' => 'testhost',
        'hosts_file_user' => 'backuppc',
        'system_account' => 'backup',
        'system_home_directory' => '/var/backups',
      }
      context 'with defaults' do
        let(:params) { default_params }

        it { is_expected.to contain_class('backuppc::client') }
        it { is_expected.to contain_class('backuppc::params') }
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/var/backups/.ssh').with_ensure('directory') }
        it { is_expected.to contain_package('rsync') }
        it { is_expected.to contain_user('backup') }

        # TODO: add tests for content
        it { is_expected.to contain_file('/var/backups/backuppc.sh') }
        it { is_expected.to contain_file('/etc/sudoers.d/backuppc') }
        it { is_expected.to contain_file('/etc/sudoers.d/backuppc_noexec') }

        context 'exported resources' do
          subject { exported_resources }

          it { is_expected.to contain_augeas('backuppc_host_testhost-create') }
          it { is_expected.to contain_augeas('backuppc_host_testhost-update') }

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

      context 'with parameters' do
        context 'exported resources' do
          subject { exported_resources }

          # it { is_expected.to contain_augeas('backuppc_host_testhost-create') }
          # it { is_expected.to contain_augeas('backuppc_host_testhost-update') }

          config_params = {
            'backup_files_exclude' => ['/junk'],
            'backup_files_only' => ['/'],
            'backups_disable' => true,
            'blackout_bad_ping_limit' => 100,
            'blackout_good_cnt' => 10,
            # 'blackout_periods' => [ { 'hourBegin' => 7, 'hourEnd' => 23, 'weekDays' => [1,2,3,4,5] } ],
            # 'client_name_alias' => 'clientname',
            # 'dump_post_share_cmd' => ,
            # 'dump_post_user_cmd' => ,
            # 'dump_pre_share_cmd' => ,
            # 'dump_pre_user_cmd' => ,
            # 'email_admin_user_name' => ,
            # 'email_destination_domain' => ,
            # 'email_from_user_name' => ,
            # 'email_notify_min_days' => ,
            # 'email_notify_old_backup_days' => ,
            # 'full_age_max' => ,
            # 'full_keep_cnt' => ,
            # 'full_period' => ,
            # 'incr_age_max' => ,
            # 'incr_fill' => ,
            # 'incr_keep_cnt' => ,
            # 'incr_levels' => ,
            # 'incr_period' => ,
            # 'partial_age_max' => ,
            # 'ping_cmd' => ,
            # 'ping_max_msec' => ,
            # 'restore_post_user_cmd' => ,
            # 'restore_pre_user_cmd' => ,
            # 'rsync_args' => ,
            # 'rsync_args_extra' => ,
            # 'rsync_client_cmd' => ,
            # 'rsync_client_restore_cmd' => ,
            # 'rsync_csum_cache_verify_prob' => ,
            # 'rsyncd_auth_required' => ,
            # 'rsyncd_client_port' => ,
            # 'rsyncd_passwd' => ,
            # 'rsyncd_user_name' => ,
            # 'rsync_restore_args' => ,
            # 'rsync_share_name' => ,
            # 'smb_share_name' => ,
            # 'smb_share_passwd' => ,
            # 'smb_share_username' => ,
            # 'tar_client_restore_cmd' => ,
            # 'tar_full_args' => ,
            # 'tar_incr_args' => ,
            # 'user_cmd_check_status' => ,
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
