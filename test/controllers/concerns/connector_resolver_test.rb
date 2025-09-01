require 'test_helper'

class ConnectorResolverTest < ActionController::TestCase
  class DummyController < ActionController::Base
    include LoggingCommon
    include ConnectorResolver

    before_action :parse_connector_type
    before_action :build_repo_url
    before_action :validate_repo_url

    def show
      render json: { 
        scheme: @repo_url&.scheme, 
        port: @repo_url&.port,
        domain: @repo_url&.domain
      }
    end
  end

  tests DummyController

  def setup
    @routes = ActionDispatch::Routing::RouteSet.new
    @routes.draw do
      get 'show' => 'connector_resolver_test/dummy#show'
      root to: 'connector_resolver_test/dummy#show'
    end
    @request.env['action_dispatch.routes'] = @routes
  end

  def stub_resolver(type:, object_url: 'https://example.org/')
    mock_service = mock('RepoResolverService')
    mock_service.stubs(:resolve).returns(Repo::RepoResolverResponse.new(object_url, type))
    ::Configuration.stubs(:repo_resolver_service).returns(mock_service)
  end

  test 'validate_repo_url redirects when repo type mismatches' do
    stub_resolver(type: ConnectorType.get('dataverse'), object_url: 'https://example.org/')
    get :show, params: { connector_type: 'zenodo', server_domain: 'example.org' }
    assert_redirected_to '/'
  end

  test 'validate_repo_url allows matching repo type' do
    stub_resolver(type: ConnectorType.get('zenodo'), object_url: 'https://example.org/')
    get :show, params: { connector_type: 'zenodo', server_domain: 'example.org' }
    assert_response :success
  end

  test 'build_repo_url uses https when server_scheme is empty' do
    stub_resolver(type: ConnectorType.get('zenodo'), object_url: 'https://example.org/')
    get :show, params: { connector_type: 'zenodo', server_domain: 'example.org', server_scheme: '' }
    assert_response :success
    response_data = JSON.parse(response.body)
    assert_equal 'https', response_data['scheme']
  end

  test 'build_repo_url uses https when server_scheme is nil' do
    stub_resolver(type: ConnectorType.get('zenodo'), object_url: 'https://example.org/')
    get :show, params: { connector_type: 'zenodo', server_domain: 'example.org', server_scheme: nil }
    assert_response :success
    response_data = JSON.parse(response.body)
    assert_equal 'https', response_data['scheme']
  end

  test 'build_repo_url uses default port when server_port is empty' do
    stub_resolver(type: ConnectorType.get('zenodo'), object_url: 'https://example.org/')
    get :show, params: { connector_type: 'zenodo', server_domain: 'example.org', server_port: '' }
    assert_response :success
    response_data = JSON.parse(response.body)
    assert_nil response_data['port']
  end

  test 'build_repo_url uses default port when server_port is nil' do
    stub_resolver(type: ConnectorType.get('zenodo'), object_url: 'https://example.org/')
    get :show, params: { connector_type: 'zenodo', server_domain: 'example.org', server_port: nil }
    assert_response :success
    response_data = JSON.parse(response.body)
    assert_nil response_data['port']
  end

  test 'build_repo_url respects custom scheme and port' do
    stub_resolver(type: ConnectorType.get('zenodo'), object_url: 'http://example.org:8080/')
    get :show, params: { connector_type: 'zenodo', server_domain: 'example.org', server_scheme: 'http', server_port: '8080' }
    assert_response :success
    response_data = JSON.parse(response.body)
    assert_equal 'http', response_data['scheme']
    assert_equal 8080, response_data['port']
  end
end
