module JSONAPI
  module Config

    def namespace
      "api/v1"
    end

    def base_url
      "http://localhost:4000/#{namespace}"
    end

    def resource_url
      "http://localhost:4000/#{namespace}/#{className.downcase.pluralize}"
    end

  end
end
