require 'test_helper'

class ContactoControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should post contacto email" do
  	post :contacto_email, :contacto => {:name => "rob", :email => 'pas@email.com', :message => "mensaje" } 
  	assert_match /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, assigns[:email]
  	assert_not_nil assigns["name"]
  	assert_not_nil assigns["email"]
  	assert_not_nil assigns["message"]
  	assert_redirected_to :contacto_success
  end
end
