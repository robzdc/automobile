require 'test_helper'

class CompareMakesControllerTest < ActionController::TestCase
  setup do
    @compare_make = compare_makes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:compare_makes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create compare_make" do
    assert_difference('CompareMake.count') do
      post :create, compare_make: { make_id: @compare_make.make_id, value: @compare_make.value, website_id: @compare_make.website_id }
    end

    assert_redirected_to compare_make_path(assigns(:compare_make))
  end

  test "should show compare_make" do
    get :show, id: @compare_make
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @compare_make
    assert_response :success
  end

  test "should update compare_make" do
    patch :update, id: @compare_make, compare_make: { make_id: @compare_make.make_id, value: @compare_make.value, website_id: @compare_make.website_id }
    assert_redirected_to compare_make_path(assigns(:compare_make))
  end

  test "should destroy compare_make" do
    assert_difference('CompareMake.count', -1) do
      delete :destroy, id: @compare_make
    end

    assert_redirected_to compare_makes_path
  end
end
