require 'spec_helper'

describe 'backuppc::server' do
  let(:pre_condition) { 'include backuppc::params' }

  describe 'On an unknown operating system' do
    let(:facts) { { 'os' => { 'family' => 'Unknown', 'name' => 'Unknown' } } }

    it { is_expected.to compile.and_raise_error(%r{is not supported by this module}) }
  end

  default_params = { 'backuppc_password' => 'test_password' }
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:options) do
        case facts[:os]['family']
        when 'RedHat'
          { group_apache: 'apache',
            topdir: '/var/lib/BackupPC' }
        when 'Debian'
          { group_apache: 'www-data',
            topdir: '/var/lib/backuppc' }
        end
      end

      context 'with defaults' do
        let(:params) { default_params }

        it { is_expected.to contain_class('backuppc::server') }
        it { is_expected.to contain_class('backuppc::params') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('backuppc') }
        it do
          is_expected.to contain_file('config_directory').with(
            ensure: 'directory',
            group: options[:group_apache],
          )
        end
        it do
          is_expected.to contain_file('config.pl').with(
            ensure: 'present',
            group: options[:group_apache],
            mode: '0640',
          )
        end
        it { is_expected.to contain_file('pc_directory_symlink').with_ensure('link') }
        it { is_expected.to contain_service('backuppc').with_ensure(true) }
        it { is_expected.to contain_file('topdir').with_ensure('directory') }
        it { is_expected.to contain_file('topdir_ssh').with_ensure('directory') }
        it { is_expected.to contain_file('apache_config').with_ensure('present') }
        it { is_expected.to contain_backuppc__server__user('backuppc').with_password('test_password') }
      end

      test_params = {
        'wakeup_schedule' => [1, 2, 3, 4],
        'max_backups' => 3,
        'max_user_backups' => 5,
        'language' => 'de',
        'max_pending_cmds' => 12,
        'max_backuppc_nightly_jobs' => 5,
        'backuppc_nightly_period' => 2,
        'max_old_log_files' => 7,
        'df_max_usage_pct' => 89,
        'trash_clean_sleep_sec' => 299,
        'full_period' => 13.97,
        'full_keep_cnt' => [4, 2, 3],
        'full_age_max' => 89,
        'incr_period' => 0.57,
        'incr_keep_cnt' => 5,
        'incr_age_max' => 29,
        'incr_levels' => [1, 2, 3],
        'incr_fill' => true,
        'partial_age_max' => 2,
        'restore_info_keep_cnt' => 11,
        'archive_info_keep_cnt' => 11,
        'blackout_good_cnt' => 5,
        'cgi_url' => 'http://localhost/backuppc/',
        'backup_zero_files_is_fatal' => false,
        'email_notify_min_days' => 2.1,
        'email_from_user_name' => 'backup_user',
        'email_admin_user_name' => 'backup_user',
        'email_user_dest_domain' => 'example.com',
        'email_notify_old_backup_days' => 11,
        'cgi_image_dir_url' => '/images',
        'cgi_admin_users' => 'backup',
        'cgi_admin_user_group' => 'backup',
        'cgi_date_format_mmdd' => 2,
        'user_cmd_check_status' => false,
        'ping_max_msec' => 4,
      }
      test_params.each do |tparam, tvalue|
        context "with #{tparam} = #{tvalue}" do
          let(:params) { default_params.merge(tparam => tvalue) }

          fparam = tparam.split('_').map { |e|
            case e
            when 'backuppc'
              'BackupPC'
            when 'email'
              'EMail'
            when 'url', 'mmdd'
              e.upcase
            else
              e.capitalize
            end
          }.join

          fvalue = case tvalue
                   when String
                     "'" + Regexp.escape(tvalue) + "'"
                   when FalseClass, TrueClass
                     tvalue ? 1 : 0
                   when Array
                     Regexp.escape('[' + tvalue.join(', ') + ']')
                   else
                     tvalue
                   end

          it { is_expected.to contain_file('config.pl').with_content(%r{^\$Conf{#{fparam}}\s+=\s+#{fvalue};}) }
        end
      end
    end
  end
end
