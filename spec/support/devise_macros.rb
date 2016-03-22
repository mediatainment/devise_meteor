module DeviseMacros

  # map_devise_user, map_devise_admin is usually used in ControllerTests to tell devise
  # which controller scope should be used
  # (you can have more than one e.g. :admin, :premium)
  # use this  if you don't sign in any user, but need basic devise functionality

  def map_devise_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def map_devise_admin
    @request.env["devise.mapping"] = Devise.mappings[:admin]
  end

  # creates an user and signs out
  # assigns @user

  def create_user(user_attributes=nil)

    map_devise_user

    if user_attributes.nil?
      user_attributes = FactoryGirl.attributes_for :user
    end

    @user_attr = user_attributes
    @user = User.new(@user_attr)
    @user.skip_confirmation!
    @user.save!

    sign_out @user
  end

  # creates and login a user
  # assigns @user

  def login_user(user=nil)
    map_devise_user
    @user = user || FactoryGirl.create(:user)
    # or set a confirmed_at inside the factory.
    # Only necessary if you are using the "confirmable" module
    @user.confirm
    sign_in @user
  end


  # creates an admin and signs in
  # assigns @admin

  def login_admin(admin=nil)
    map_devise_admin
    @admin = admin || FactoryGirl.create(:admin)
    sign_in @admin
  end


end