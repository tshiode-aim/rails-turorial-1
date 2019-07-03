require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar",
        }
      }
      assert_template 'users/new'
      assert_select 'div#error_explanation > ul > li', "Name can't be blank"
      assert_select 'div#error_explanation > ul > li', "Email is invalid"
      assert_select 'div#error_explanation > ul > li', "Password confirmation doesn't match Password"
      assert_select 'div#error_explanation > ul > li', "Password is too short (minimum is 6 characters)"
      assert_select 'form[action="/signup"]'
    end
  end
end
