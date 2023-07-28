# @summary
#   Handle OpenSearch Dashboards service.
#
# @api private
#
class opensearch_dashboards::service {
  assert_private()

  if $opensearch_dashboards::manage_service {
    if $opensearch_dashboards::package_source == 'archive' {
      systemd::unit_file { 'opensearch-dashboards.service':
        ensure => 'present',
        source => "puppet:///modules/${module_name}/opensearch-dashboards.service",
      }
    }

    service { 'opensearch-dashboards':
      ensure => $opensearch_dashboards::service_ensure,
      enable => $opensearch_dashboards::service_enable,
    }
  }
}
