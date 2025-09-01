require 'test_helper'

class Zenodo::UploadBundleConnectorProcessorTest < ActiveSupport::TestCase
  include ModelHelper

  def setup
    @processor = Zenodo::UploadBundleConnectorProcessor.new
    @project = create_project
    @bundle = create_upload_bundle(@project)
  end

  test 'params schema' do
    assert_includes @processor.params_schema, :remote_repo_url
  end

  test 'create delegates to action' do
    action = mock('action')
    Zenodo::Handlers::UploadBundleCreate.expects(:new).returns(action)
    action.expects(:create).with(@project, {foo: 'bar'}).returns(:result)
    assert_equal :result, @processor.create(@project, {foo: 'bar'})
  end

  test 'edit returns connector result by default' do
    result = @processor.edit(@bundle, {})
    assert_equal '/connectors/zenodo/connector_edit_form', result.template
    assert_equal({upload_bundle: @bundle}, result.locals)
  end

  test 'edit uses dataset_form_tabs form' do
    action = mock('action')
    Zenodo::Handlers::DatasetFormTabs.expects(:new).returns(action)
    action.expects(:edit).with(@bundle, {form: 'dataset_form_tabs'}).returns(:ok)
    assert_equal :ok, @processor.edit(@bundle, {form: 'dataset_form_tabs'})
  end

  test 'update uses deposition_fetch form' do
    action = mock('action')
    Zenodo::Handlers::DepositionFetch.expects(:new).returns(action)
    action.expects(:update).with(@bundle, {form: 'deposition_fetch'}).returns(:ok)
    assert_equal :ok, @processor.update(@bundle, {form: 'deposition_fetch'})
  end

  test 'update uses deposition_create form' do
    action = mock('action')
    Zenodo::Handlers::DepositionCreate.expects(:new).returns(action)
    action.expects(:update).with(@bundle, {form: 'deposition_create'}).returns(:ok)
    assert_equal :ok, @processor.update(@bundle, {form: 'deposition_create'})
  end

  test 'update uses dataset_select form' do
    action = mock('action')
    Zenodo::Handlers::DatasetSelect.expects(:new).returns(action)
    action.expects(:update).with(@bundle, {form: 'dataset_select'}).returns(:ok)
    assert_equal :ok, @processor.update(@bundle, {form: 'dataset_select'})
  end

  test 'update default routes to connector edit' do
    action = mock('action')
    Zenodo::Handlers::ConnectorEdit.expects(:new).returns(action)
    action.expects(:update).with(@bundle, {}).returns(:ok)
    assert_equal :ok, @processor.update(@bundle, {})
  end
end
