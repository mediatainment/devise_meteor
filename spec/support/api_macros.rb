module ApiMacros

  USER_TOKEN_FIELD = 'X-User-Token'

  def request_with_user_session(method, path, params={}, headers={})
    headers.merge!(USER_TOKEN_FIELD => retrieve_access_token)
    send(method, path, params: params, headers: headers)
  end

  def get_with_token(path, params={}, headers={})
    headers.merge!(USER_TOKEN_FIELD => @user.authentication_token)
    get path, params: params, headers: headers
  end

  # make a POST with
  def post_with_token(path, params={}, headers={})
    headers.merge!(USER_TOKEN_FIELD => @user.authentication_token)
    post path, params: params, headers: headers
  end

  # stub out authenticate_request
  def stub_request
    ApplicationController.any_instance.stub(:authenticate_request) { true }
  end

  # Rails.application shortcut
  def app
    Rails.application
  end
end