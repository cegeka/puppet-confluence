  require 'spec_helper_acceptance'

describe 'confluence' do

  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS

      include 'yum'
      include 'cegekarepos'
      include 'profile::package_management'
      Yum::Repo <| title == 'cegeka-unsigned' |>
      sunjdk::instance { 'jdk-1.8.0_05-fcs':
        ensure      => 'present',
        jdk_version => '1.8.0_05-fcs',
        require     => Yum::Repo['cegeka-unsigned']
      }

      class { 'confluence':
        version      => '6.10.0',
        checksum     => '6c982c7f4356e2f121022fc87dc70a45',
        javahome     => '/usr/java/jdk1.8.0_05/'
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service('confluence') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file '/opt/confluence' do	
      it { is_expected.to be_directory }	
    end
  end
end
