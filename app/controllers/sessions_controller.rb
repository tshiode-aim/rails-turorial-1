class SessionsController < ApplicationController
  def new
    # empty
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      ## ユーザーログインあとにユーザ情報のページにリダイレクトする
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # empty
  end
end
