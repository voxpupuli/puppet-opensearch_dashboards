# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'opensearch_dashboards' do
  context 'default parameter' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        'include opensearch_dashboards'
      end
    end

    describe package('opensearch-dashboards') do
      it { is_expected.to be_installed }
    end

    describe service('opensearch-dashboards') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file('/etc/opensearch-dashboards') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'opensearch-dashboards' }
      it { is_expected.to be_grouped_into 'opensearch-dashboards' }
    end

    describe file('/etc/opensearch-dashboards/opensearch_dashboards.yml') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'opensearch-dashboards' }
      it { is_expected.to be_grouped_into 'opensearch-dashboards' }
    end
  end
end
