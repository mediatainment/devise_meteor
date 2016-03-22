module ControllerMacros

  # This method uses warden
  # sign in a given user or creates one automatically
  # nil allows to force not logged in user
  def sign_up_and_in(user_attributes=FactoryGirl.attributes_for(:user))

    if user_attributes
      create_user(user_attributes)
      allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
      allow(controller).to receive(:current_user).and_return(@user)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    end
  end

end