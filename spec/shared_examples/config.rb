# frozen_string_literal: true

shared_examples 'config' do |parameter, _facts|
  it {
    is_expected.to contain_class('opensearch_dashboards::config').that_comes_before('Class[opensearch_dashboards::service]')
  }

  if parameter['restart_on_config_change']
    it {
      is_expected.to contain_class('opensearch_dashboards::config').that_notifies('Class[opensearch_dashboards::service]')
    }
  end

  if parameter['manage_config']
    config_directory = case parameter['package_source']
                       when 'archive'
                         "#{parameter['package_directory']}/config"
                       else
                         '/etc/opensearch-dashboards'
                       end

    settings = parameter['settings']

    require 'yaml'

    it {
      is_expected.to contain_file("#{config_directory}/opensearch_dashboards.yml").with(
        {
          'ensure'  => 'file',
          'owner'   => 'opensearch-dashboards',
          'group'   => 'opensearch-dashboards',
          'mode'    => '0640',
          'content' => settings.to_yaml,
        }
      )
    }
  end
end
