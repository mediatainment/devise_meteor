module RequestMacros

  # login a given user by passing a TOKEN
  def login(user)
    post_via_redirect user_session_path, headers: {'X-User-Token' => user.authentication_token}
  end

  # logout a given user by passing a TOKEN
  def logout(user)
    post_via_redirect destroy_user_session_path, headers: {'X-User-Token' => user.authentication_token}
  end

end