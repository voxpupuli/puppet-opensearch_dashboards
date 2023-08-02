# frozen_string_literal: true

def default_parameters
  {
    ##
    ## version
    ##
    'version'                   => :undef,

    ##
    ## package
    ##
    'manage_package'            => true,
    'package_directory'         => '/opt/opensearch-dashboards',
    'package_ensure'            => 'present',
    'package_source'            => 'repository',
    'pin_package'               => true,
    'apt_pin_priority'          => 1001,

    ##
    ## repository
    ##
    'manage_repository'         => true,
    'repository_ensure'         => 'present',
    'repository_location'       => :undef,
    'repository_gpg_key'        => 'https://artifacts.opensearch.org/publickeys/opensearch.pgp',

    ##
    ## settings
    ##
    'manage_config'             => true,
    'settings'                  => {},

    ##
    ## service
    ##
    'manage_service'            => true,
    'service_ensure'            => 'running',
    'service_enable'            => true,
    'restart_on_config_change'  => true,
    'restart_on_package_change' => true,
  }
end
