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
      let(:params) do
        {
          'backuppc_hostname' => 'backuppc.test.com',
          'config_name' => 'testhost',
        }
      end

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

        it { is_expected.to contain_file(file_host) }
        it { is_expected.to contain_augeas('backuppc_host_testhost-create') }
        it { is_expected.to contain_augeas('backuppc_host_testhost-update') }
      end
    end
  end
end
