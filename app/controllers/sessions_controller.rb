class SessionsController < ApplicationController
def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
	sign_out
        redirect_to root_url
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token)) #change the user’s remember token in the database (in case the cookie has been stolen, as it could still be used to authorize a user)
    cookies.delete(:remember_token)
    self.current_user = nil
  end
end
