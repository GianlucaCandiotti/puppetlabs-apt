require 'spec_helper_acceptance'

describe 'apt class' do

  context 'reset' do
    it 'fixes the sources.list' do
      shell('cp /etc/apt/sources.list /tmp')
    end
  end

  context 'all the things' do
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'apt':
        update => {
          'frequency' => 'always',
          'timeout'   => '400',
          'tries'     => '3',
        },
        purge => {
          'sources.list'   => true,
          'sources.list.d' => true,
          'preferences'    => true,
          'preferences.d'  => true,
        },
        sources => {
          'puppetlabs' => {
            'ensure'   => present,
            'location' => 'http://apt.puppetlabs.com',
            'repos'    => 'main',
            'key'      => {
              'id'     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
              'server' => 'pgp.mit.edu',
            },
          },
        },
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_failures => true)
    end
    it 'should still work' do
      shell('apt-get update')
      shell('apt-get -y --force-yes upgrade')
    end
  end

  context 'reset' do
    it 'fixes the sources.list' do
      shell('cp /tmp/sources.list /etc/apt')
    end
  end

end
