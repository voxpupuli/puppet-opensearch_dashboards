# frozen_string_literal: true

shared_examples 'service' do |parameter, _facts|
  it {
    is_expected.to contain_class('opensearch_dashboards::service')
  }

  if parameter['manage_service']
    if parameter['package_source'] == 'archive'
      it {
        is_expected.to contain_systemd__unit_file('opensearch-dashboards.service').with(
          {
            'ensure' => 'present',
            'source' => 'puppet:///modules/opensearch_dashboards/opensearch-dashboards.service',
          }
        )
      }
    end

    it {
      is_expected.to contain_service('opensearch-dashboards').with(
        {
          'ensure' => parameter['service_ensure'],
          'enable' => parameter['service_enable'],
        }
      )
    }
  end
end
