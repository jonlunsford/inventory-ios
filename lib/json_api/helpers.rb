module JSONAPI
  module Helpers
    def parse_request_errors(http_result)
      info = http_result.error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]

      return http_result.error.localizedDescription unless info

      errors = BW::JSON.parse(info)['errors']
      errors ? errors.map { |e| e['detail'] }.join(', ') : []
    end
  end
end
