class User < CDQManagedObject
  include JSONAPI::Serializers::CDQ

  def register
    AFMotion::JSON.post("#{base_url}/register", registration_params) do |result|
      #mp result.operation.response.URL

      if result.success?
        log_in
      elsif result.failure?
        parse_request_errors(result)
      end
    end
  end

  def log_in
    AFMotion::JSON.post("#{base_url}/token", login_params) do |result|
      if result.success?
        create_or_update_session_with_token(result.object['access_token'])
      elsif result.failure?
        parse_request_errors(result)
      end
    end
  end

  private

  def create_or_update_session_with_token(token)
    if session
      mp 'UPDATE SESSION'
      session.token = token
    else
      mp 'CREATE SESSION'
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

