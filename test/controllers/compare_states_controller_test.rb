require 'test_helper'

class CompareStatesControllerTest < ActionController::TestCase
  setup do
    @compare_state = compare_states(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:compare_states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create compare_state" do
    assert_difference('CompareState.count') do
      post :create, compare_state: { state_id: @compare_state.state_id, value: @compare_state.value, website_id: @compare_state.website_id }
    end

    assert_redirected_to compare_state_path(assigns(:compare_state))
  end

  test "should show compare_state" do
    get :show, id: @compare_state
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @compare_state
    assert_response :success
  end

  test "should update compare_state" do
    patch :update, id: @compare_state, compare_state: { state_id: @compare_state.state_id, value: @compare_state.value, website_id: @compare_state.website_id }
    assert_redirected_to compare_state_path(assigns(:compare_state))
  end

  test "should destroy compare_state" do
    assert_difference('CompareState.count', -1) do
      delete :destroy, id: @compare_state
    end

    assert_redirected_to compare_states_path
  end
end
