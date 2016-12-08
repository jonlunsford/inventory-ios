module JSONAPI
  module Serializers
    module CDQ
      attr_accessor :request_errors

      include JSONAPI::Config
      extend MotionSupport::Concern

      module ClassMethods
        def from_json(json)
          params = BW::JSON.parse(json)["data"]
          attributes = params["attributes"].merge({ id: params["id"] })
          self.create(attributes)
        end
      end

      def serialize
        id = denilized_attributes.delete(:id)

        {
          data: {
            type: className.downcase.pluralize,
            id: id,
            attributes: denilized_attributes,
            relationships: related,
            links: {
              self: "#{resource_url}/#{id}"
            }
          }
        }
      end

      def to_json
        BW::JSON.generate serialize
      end

      def client
        @client ||= JSONAPI::Client.new(resource_url)
      end

      def request_errors=(errors)
        @request_errors = errors
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
          related: "#{resource_url}/#{denilized_attributes[:id]}/#{link_name}"
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
end
