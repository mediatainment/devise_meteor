module OmniauthMacros

  def setup_for_login(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = send("params_#{provider}")
  end

  # create a mock response for omniauth providers
  def mock_omniauth(provider, test_mode=true)

    # call method with mock values and attributes for given provider
    params_provider = send("params_#{provider}")

    # deactivate test_mode
    OmniAuth.config.test_mode = test_mode ? true : false

    #deliver omniauth mock credentials
    OmniAuth.config.add_mock(provider.to_sym, params_provider)
  end

  def params_facebook
    {:info => {email: Faker::Internet.email},
     user_info: {name: Faker::Name.name,
                 image: '',
                 email: Faker::Internet.email},
     uid: "#{Faker::Number.number(10)}",
     provider: 'facebook',
     credentials: {token: 'token'}}
  end

  def params_twitter
    {:provider => :twitter,
     :uuid => '1234',
     :credentials => {:token => "1234567890134567890"},
     :info => {email: Faker::Internet.email}
    }
  end

  def params_github
    {'provider' => 'github',
     'uid' => "#{Faker::Number.number(10)}"
    }
  end

end