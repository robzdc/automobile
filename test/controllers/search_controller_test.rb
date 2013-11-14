require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get getmodels" do
  	@request.env['HTTP_ACCEPT'] = "application/json"
    get :getmodels, get: {make_id: 1}
    
    assert :getmodels, "Got models"
    assert_response :success
  end

end
