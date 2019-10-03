require 'spec_helper'

describe 'Facter::Util::Fact::backuppc_pubkey_rsa', type: :fact do
  before(:each) { Facter.clear }
  after(:each) { Facter.clear }
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:content) { StringIO.new('ssh-rsa xxx_key_xxx user@host') }
      let(:path) do
        case facts[:osfamily]
        when 'RedHat'
          '/var/lib/BackupPC/.ssh/id_rsa.pub'
        when 'Debian'
          '/var/lib/backuppc/.ssh/id_rsa.pub'
        end
      end

      before(:each) do
        allow(Facter.fact(:osfamily)).to receive(:value).and_return(facts[:osfamily])
        allow(File).to receive(:exist?).with(path).and_return(true)
        allow(File).to receive(:open).with(path).and_return(content)
      end
      it 'with extracted key xxx_key_xxx' do
        expect(Facter.fact(:backuppc_pubkey_rsa).value).to eq('xxx_key_xxx')
      end
    end
  end
end
