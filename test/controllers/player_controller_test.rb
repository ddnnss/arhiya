require 'test_helper'

class PlayerControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get player_login_url
    assert_response :success
  end

end
