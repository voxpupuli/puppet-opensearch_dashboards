# frozen_string_literal: true

shared_examples 'install' do |parameter, facts|
  it {
    is_expected.to contain_class('opensearch_dashboards::install').that_comes_before('Class[opensearch_dashboards::config]')
  }

  if parameter['restart_on_package_change']
    it {
      is_expected.to contain_class('opensearch_dashboards::install').that_notifies('Class[opensearch_dashboards::service]')
    }
  end

  if parameter['manage_package']
    if parameter['package_source'] == 'archive'
      include_examples 'install_archive', parameter
    else
      include_examples 'install_package', parameter, facts
    end
  end
end
