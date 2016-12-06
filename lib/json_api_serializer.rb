module JSONAPI
  module Serializer
    extend MotionSupport::Concern

    module ClassMethods
      def from_json(json)
        params = BW::JSON.parse(json)["data"]
        self.create(params["attributes"])
      end
    end

    def namespace
      "api/v1"
    end

    def base_url
      "http://localhost:4000/#{namespace}/#{className.downcase.pluralize}"
    end

    def serialize
      {
        data: {
          type: className.downcase.pluralize,
          attributes: denilized_attributes,
          relationships: related
        }
      }
    end

    def to_json
      BW::JSON.generate serialize
    end

    private

    def denilized_attributes
      @denilized_attributes ||= attributes.delete_if { |key, value| value.nil? }.symbolize_keys
    end

    def related
      entity.relationshipsByName.keys.inject({}) do |memo, key|
        sym = key.to_sym

        memo[sym] = {}
        memo[sym][:links] = get_link(key) if exists?
        memo[sym][:data] = serialize_related_data(key, self.send(sym))
        memo
      end
    end

    def get_link(link_name)
      {
        related: "#{base_url}/#{denilized_attributes[:id]}/#{link_name}"
      }
    end

    def serialize_related_data(type, record)
      if is_one? record
        to_data_hash(type, record)
      elsif is_many? record
        many_to_data_array(type.pluralize, record)
      else
        nil
      end
    end

    def to_data_hash(type, record)
      { type: type, id: record.id }
    end

    def many_to_data_array(type, collection)
      collection.map { |record| to_data_hash(type, record) }
    end

    def is_one?(record)
      record && record.respond_to?(:id) && record.id > 0
    end

    def is_many?(collection)
      collection && collection.respond_to?(:map)
    end

    def exists?
      denilized_attributes[:id] && denilized_attributes[:id] > 0
    end

  end
end
