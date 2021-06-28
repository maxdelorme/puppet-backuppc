require 'spec_helper'

describe 'backuppc::client' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { { 'backuppc_hostname' => 'backuppc.test.com' } }

      it { is_expected.to contain_class('backuppc::client') }
      it { is_expected.to contain_class('backuppc::params') }
      it { is_expected.to compile.with_all_deps }
    end
  end
end
