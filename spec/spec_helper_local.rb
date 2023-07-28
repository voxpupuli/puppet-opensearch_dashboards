# frozen_string_literal: true

require 'shared_examples/config'
require 'shared_examples/install_archive'
require 'shared_examples/install_package'
require 'shared_examples/install'
require 'shared_examples/repository_debian'
require 'shared_examples/repository_redhat'
require 'shared_examples/repository'
require 'shared_examples/service'

require 'helper/get_defaults'

TESTS = {
  'with default value' => {},
  'with installation via archive and version 2.6.0' => {
    'version' => '2.6.0',
    'package_source' => 'archive',
  },
  'with installation via download and version 2.6.0' => {
    'version' => '2.6.0',
    'package_source' => 'download',
  },
  'with some settings given' => {
    'settings' => {
      'server.port' => 5602,
      'opensearch.hosts' => [
        'https://opensearch.exapmle.com:9201',
      ],
    },
  },
}.freeze
