require 'test_helper'

class CompareModelsControllerTest < ActionController::TestCase
  setup do
    @compare_model = compare_models(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:compare_models)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create compare_model" do
    assert_difference('CompareModel.count') do
      post :create, compare_model: { model_id: @compare_model.model_id, value: @compare_model.value, website_id: @compare_model.website_id }
    end

    assert_redirected_to compare_model_path(assigns(:compare_model))
  end

  test "should show compare_model" do
    get :show, id: @compare_model
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @compare_model
    assert_response :success
  end

  test "should update compare_model" do
    patch :update, id: @compare_model, compare_model: { model_id: @compare_model.model_id, value: @compare_model.value, website_id: @compare_model.website_id }
    assert_redirected_to compare_model_path(assigns(:compare_model))
  end

  test "should destroy compare_model" do
    assert_difference('CompareModel.count', -1) do
      delete :destroy, id: @compare_model
    end

    assert_redirected_to compare_models_path
  end
end
