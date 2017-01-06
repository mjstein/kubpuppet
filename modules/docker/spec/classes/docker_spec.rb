require 'spec_helper'

describe 'docker', :type => :class do

  context "on RedHat" do
    let(:facts) { {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '6.5'
      } }
    service_config_file = '/etc/sysconfig/docker'
    storage_config_file = '/etc/sysconfig/docker-storage'

    context 'when given a specific tmp_dir' do
      let(:params) { { :tmp_dir => '/bigtmp' } }
      it { should contain_file('/etc/sysconfig/docker').with_content(/export TMPDIR="\/bigtmp"/) }
    end

    it { should compile.with_all_deps }
    it { should contain_class('docker::install').that_comes_before('Class[docker::config]') }
    it { should contain_class('docker::service').that_subscribes_to('Class[docker::config]') }
    it { should contain_class('docker::config') }

    context 'with storage driver param' do
      let(:params) { { 'storage_driver' => 'devicemapper' }}
      it { should contain_file(storage_config_file).with_content(/--storage-driver=devicemapper/) }
    end

    context 'without execdriver param' do
      it { should_not contain_file(service_config_file).with_content(/-e lxc/) }
      it { should_not contain_file(service_config_file).with_content(/-e native/) }
    end

    context 'with dns param' do
      let(:params) { {'dns' => '8.8.8.8'} }
      it { should contain_file(service_config_file).with_content(/--dns 8.8.8.8/) }
    end

    context 'with dns_search param' do
      let(:params) { {'dns_search' => 'my.domain.local'} }
      it { should contain_file(service_config_file).with_content(/--dns-search my.domain.local/) }
    end

    context 'with multi extra parameters' do
      let(:params) { {'extra_parameters' => ['--this this', '--that that'] } }
      it { should contain_file(service_config_file).with_content(/--this this/) }
      it { should contain_file(service_config_file).with_content(/--that that/) }
    end

    context 'with a string extra parameters' do
      let(:params) { {'extra_parameters' => '--this this' } }
      it { should contain_file(service_config_file).with_content(/--this this/) }
    end

    context 'with service_state set to stopped' do
      let(:params) { {'service_state' => 'stopped'} }
      it { should contain_service('docker').with_ensure('stopped') }
    end

    context 'with service_enable set to false' do
      let(:params) { {'service_enable' => 'false'} }
      it { should contain_service('docker').with_enable('false') }
    end

    context 'with service_enable set to true' do
      let(:params) { {'service_enable' => 'true'} }
      it { should contain_service('docker').with_enable('true') }
    end

    context 'with specific log_level' do
      let(:params) { { 'log_level' => 'debug' } }
      it { should contain_file(service_config_file).with_content(/-l debug/) }
    end

    context 'with an invalid log_level' do
      let(:params) { { 'log_level' => 'verbose'} }
      it do
        expect {
          should contain_package('docker')
        }.to raise_error(Puppet::Error, /log_level must be one of debug, info, warn, error or fatal/)
      end
    end

    context 'with specific selinux_enabled parameter' do
      let(:params) { { 'selinux_enabled' => true } }
      it { should contain_file(service_config_file).with_content(/--selinux-enabled=true/) }
    end

    context 'with ensure absent' do
      let(:params) { {'ensure' => 'absent' } }
      it { should contain_package('docker').with_ensure('absent') }
    end

  end

  context 'specific to Fedora 21 or above' do
    let(:facts) { {
        :osfamily => 'RedHat',
        :operatingsystem => 'Family',
        :operatingsystemrelease => '21.0'
      } }

    it { should contain_package('docker').with_name('docker') }
    it { should_not contain_class('epel') }
  end

  context 'specific to RedHat 7 or above' do
    let(:facts) { {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '7.0',
        :operatingsystemmajrelease => '7',
      } }

    it { should contain_package('docker').with_name('docker') }
    it { should_not contain_class('epel') }
  end

  context 'specific to Oracle Linux 7 or above' do
    let(:facts) { {
        :osfamily => 'RedHat',
        :operatingsystem => 'OracleLinux',
        :operatingsystemrelease => '7.0',
        :operatingsystemmajrelease => '7',
      } }

    it { should contain_package('docker').with_name('docker') }
    it { should_not contain_class('epel') }
  end

  context 'specific to Scientific Linux 7 or above' do
    let(:facts) { {
        :osfamily => 'RedHat',
        :operatingsystem => 'Scientific',
        :operatingsystemrelease => '7.0',
        :operatingsystemmajrelease => '7',
      } }

    it { should contain_package('docker').with_name('docker') }
    it { should_not contain_class('epel') }
  end

end
