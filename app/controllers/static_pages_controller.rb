class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
    # empty
  end

  def about
    # empty
  end

  def contact
    # empty
  end
end
