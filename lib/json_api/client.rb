module JSONAPI
  class Client
    attr_accessor :base_url, :namespace

    def initialize(base_url, namespace = 'api/v1')
      @base_url = base_url
      @namespace = namespace
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

    private

    def request(method, *args, &callback)
      path = '/#{@namespace}/#{args[0]}'
      params = args[1]

      client.send(method, path, params) do |result|
        if result.success?
          yield(result.object, result.object.fetch('errors')) if callback
        elsif result.failure?
          yield(result.error, result.error.localizedDescription) if callback
        end
      end
    end

    def client
      @client ||= AFMotion::Client.build(@base_url) do
        request_serializer :json
        response_serializer :json
        header 'Accept', 'application/json'
        header 'Accept', 'application/vnd.api+json'
        authorization token: 'Bearer #{Session.first.token}'
      end
    end
  end
end
