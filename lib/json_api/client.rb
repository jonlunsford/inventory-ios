module JSONAPI
  class Client
    include JSONAPI::Helpers

    attr_accessor :base_url, :namespace

    def initialize(base_url, user, namespace = 'api/v1')
      @base_url = base_url
      @namespace = namespace
      @user = user
    end

    def get(*args, &block)
      request(:get, *args, &block)
    end

    def post(*args, &block)
      request(:post, *args, &block)
    end

    def put(*args, &block)
      request(:put, *args, &block)
    end

    def patch(*args, &block)
      request(:patch, *args, &block)
    end

    def delete(*args, &block)
      request(:delete, *args, &block)
    end

    def authenticated?
      @authenticated ||= @user.session && @user.session.token ? true : false
    end

    def authenticate
      @user.log_in
    end

    private

    def request(method, *args, &block)
      request_params = {
        method: method,
        path: "/#{@namespace}/#{args[0]}",
        params: args[1]
      }

      if authenticated?
        authenticated_request(request_params, &block)
      else
        unauthenticated_request(request_params, &block)
      end
    end

    def authenticated_request(params, &block)
      authenticated_client.send(params.fetch(:method), params.fetch(:path), params.fetch(:params)) do |result|
        yield result if block
      end
    end

    def unauthenticated_request(params, &block)
      unauthenticated_client.send(params.fetch(:method), params.fetch(:path), params.fetch(:params)) do |result|
        yield result if block
      end
    end

    def authenticated_client
      @authenticated_client ||= AFMotion::Client.build(@base_url) do
        request_serializer :json
        response_serializer :json
        header 'Accept', 'application/vnd.api+json'
        authorization token: "Bearer #{@user.session.token}"
      end
    end

    def unauthenticated_client
      @unauthenticated_client ||= AFMotion::Client.build(@base_url) do
        request_serializer :json
        response_serializer :json
        header 'Accept', 'application/vnd.api+json'
      end
    end
  end
end
