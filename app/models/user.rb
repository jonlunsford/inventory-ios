class User < CDQManagedObject
  include JSONAPI::Serializers::CDQ
  include Concerns::CDQAttributeShim

  shim_attributes!

  def register(&block)
    AFMotion::JSON.post("#{base_url}/register", registration_params) do |result|
      block.call(result) if block
    end
  end

  def log_in(&block)
    AFMotion::JSON.post("#{base_url}/token", login_params) do |result|
      create_or_update_session_with_token(result.object["access_token"])
      block.call(result) if block
    end
  end

  private

  def create_or_update_session_with_token(token)
    if session
      session.token = token
    else
      Session.create(token: token, user: self)
    end

    cdq.save
  end

  def login_params
    {
      grant_type: 'password',
      username: email,
      password: password
    }
  end

  def registration_params
    {
      data: {
        type: 'users',
        attributes: {
          email: email,
          password: password,
          password_confirmation: password_confirmation
        }
      }
    }
  end

end

