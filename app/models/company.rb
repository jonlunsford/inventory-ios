class Company < CDQManagedObject
  include JSONAPI::Serializers::CDQ
  include Concerns::CDQAttributeShim

  shim_attributes!
end
