require 'spec_helper'
require 'facter/backuppc_pubkey_rsa'

#describe 'backuppc_pubkey_rsa fact specs', type: :fact do
describe 'backuppc_pubkey_rsa fact' do
  before(:each) { Facter.clear }
  after(:each) { Facter.clear }

  let(:content) { StringIO.new('ssh-rsa xxx_key_xxx user@host') }

  describe 'backuppc_pubkey_rsa' do
    describe 'on Debian' do
      let(:path) { '/var/lib/backuppc/.ssh/id_rsa.pub' }

      before(:each) do
        allow(Facter.fact(:osfamily)).to receive(:value).and_return('Debian')
        allow(File).to receive(:exist?).with(path).and_return(true)
        allow(File).to receive(:open).with(path).and_return(content)
      end
      it 'with extracted key xxx_key_xxx' do
        expect(Facter.fact(:backuppc_pubkey_rsa).value).to eq('xxx_key_xxx')
      end
    end
    describe 'on RedHat' do
      let(:path) { '/var/lib/BackupPC/.ssh/id_rsa.pub' }

      before(:each) do
        allow(Facter.fact(:osfamily)).to receive(:value).and_return('RedHat')
        allow(File).to receive(:exist?).with(path).and_return(true)
        allow(File).to receive(:open).with(path).and_return(content)
      end
      it 'with extracted key xxx_key_xxx' do
        expect(Facter.fact(:backuppc_pubkey_rsa).value).to eq('xxx_key_xxx')
      end
    end
  end

end

#require 'spec_helper'
#
#describe Facter::Util::Fact do
#  before do
#    Facter.clear
#  end
#
#  describe 'backuppc_pubkey_rsa' do
#    context 'with value' do
#      before do
#        allow(Facter::Core::Execution).to receive(:which).with('mongo').and_return(true)
#        allow(Facter::Core::Execution).to receive(:execute).with('mongo --version 2>&1').and_return('MongoDB shell version: 3.2.1')
#      end
#      it {
#        expect(Facter.fact(:backuppc_pubkey_rsa).value).to eq('3.2.1')
#      }
#    end
#  end
#end
