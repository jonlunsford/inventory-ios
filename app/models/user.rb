class User < CDQManagedObject
  include JSONAPI::Serializers::CDQ

  def register
    AFMotion::JSON.post("#{base_url}/register", registration_params) do |result|
      #mp result.operation.response.URL

      if result.success?
        mp result.object
      elsif result.failure?
        info = result.error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
        errors = BW::JSON.parse(info)['errors']
        @request_errors = errors.map { |e| e['detail'] }
      end
    end
  end

  private

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

