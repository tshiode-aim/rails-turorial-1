require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@exaple.com")
  end

  test "should be valid" do
    assert @user.valid?
  end
end
