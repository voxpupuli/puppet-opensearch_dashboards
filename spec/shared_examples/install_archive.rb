# frozen_string_literal: true

shared_examples 'install_archive' do |parameter|
  it {
    is_expected.to contain_class('opensearch_dashboards::install::archive')
  }

  it {
    is_expected.to contain_user('opensearch-dashboards').with(
      {
        'ensure'     => parameter['package_ensure'],
        'home'       => parameter['package_directory'],
        'managehome' => false,
        'system'     => true,
        'shell'      => '/bin/false',
      }
    )
  }

  if parameter['package_ensure'] == 'present'
    it {
      is_expected.to contain_file(parameter['package_directory']).with(
        {
          'ensure' => 'directory',
          'owner'  => 'opensearch-dashboards',
          'group'  => 'opensearch-dashboards',
        }
      )
    }

    it {
      is_expected.to contain_file('/var/lib/opensearch-dashboards').with(
        {
          'ensure' => 'directory',
          'owner'  => 'opensearch-dashboards',
          'group'  => 'opensearch-dashboards',
        }
      )
    }

    it {
      is_expected.to contain_file('/var/log/opensearch-dashboards').with(
        {
          'ensure' => 'directory',
          'owner'  => 'opensearch-dashboards',
          'group'  => 'opensearch-dashboards',
        }
      )
    }

    it {
      package_architecture = case facts[:os]['architecture']
                             when %r{(amd64|x64|x86_64)}
                               'x64'
                             when 'arm64'
                               'arm64'
                             end

      file = "opensearch-dashboards-#{parameter['version']}-linux-#{package_architecture}.tar.gz"

      is_expected.to contain_archive("/tmp/#{file}").with(
        {
          'provider'        => 'wget',
          'path'            => "/tmp/#{file}",
          'extract'         => true,
          'extract_path'    => parameter['package_directory'],
          'extract_command' => "tar -xvzf /tmp/#{file} --wildcards opensearch-#{parameter['version']}/* -C #{parameter['package_directory']}",
          'user'            => 'opensearch-dashboards',
          'group'           => 'opensearch-dashboards',
          'creates'         => "#{parameter['package_directory']}/bin",
          'cleanup'         => true,
          'source'          => "https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/#{parameter['version']}/#{file}",
        }
      )
    }
  else
    it {
      is_expected.to contain_file(parameter['package_directory']).with(
        {
          'ensure'  => parameter['package_ensure'],
          'recurse' => true,
          'force'   => true,
        }
      )
    }

    it {
      is_expected.to contain_file('/var/lib/opensearch-dashboards').with(
        {
          'ensure'  => parameter['package_ensure'],
          'recurse' => true,
          'force'   => true,
        }
      )
    }

    it {
      is_expected.to contain_file('/var/log/opensearch-dashboards').with(
        {
          'ensure'  => parameter['package_ensure'],
          'recurse' => true,
          'force'   => true,
        }
      )
    }
  end
end
