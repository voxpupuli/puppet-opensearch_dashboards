# frozen_string_literal: true

shared_examples 'install_package' do |parameter, facts|
  it {
    is_expected.to contain_class('opensearch_dashboards::install::package')
  }

  if parameter['package_source'] == 'download'
    ensure_value = parameter['package_ensure']
    let(:provider) { package_provider }

    let(:package_provider) do
      case facts[:os]['family']
      when 'Debian' then 'dpkg'
      when 'RedHat' then 'rpm'
      end
    end

    let(:package_architecture) do
      case facts[:os]['architecture']
      when %r{(amd64|x64|x86_64)}
        'x64'
      when 'arm64'
        'arm64'
      end
    end

    let(:file) do
      case package_provider
      when 'dpkg'
        "opensearch-dashboards-#{parameter['version']}-linux-#{package_architecture}.deb"
      when 'rpm'
        "opensearch-dashboards-#{parameter['version']}-linux-#{package_architecture}.rpm"
      end
    end

    let(:source) { "/tmp/#{file}" }

    it {
      is_expected.to contain_archive(source).with(
        {
          'provider' => 'wget',
          'extract'  => false,
          'cleanup'  => true,
          'source'   => "https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/#{parameter['version']}/#{file}",
        }
      ).that_comes_before("Package[opensearch-dashboards]")
    }
  else
    ensure_value = if parameter['version'] == :undef
                     parameter['package_ensure']
                   else
                     parameter['version']
                   end
    let(:provider) { nil }
    let(:source) { nil }

    include_examples 'repository', parameter, facts if parameter['manage_repository']

    if (parameter['version'] != :undef) && parameter['pin_package']
      case facts[:os]['family']
      when 'Debian'
        it {
          is_expected.to contain_apt__pin('opensearch-dashboards').with(
            {
              'version'  => parameter['version'],
              'packages' => 'opensearch-dashboards',
              'priority' => parameter['apt_pin_priority'],
            }
          )
        }
      when 'RedHat'
        it {
          is_expected.to contain_yum__versionlock('opensearch-dashboards').with(
            {
              'version' => parameter['version'],
            }
          )
        }
      end
    end
  end

  it {
    is_expected.to contain_package('opensearch-dashboards').with(
      {
        'ensure'   => ensure_value,
        'provider' => provider,
        'source'   => source,
      }
    )
  }
end
