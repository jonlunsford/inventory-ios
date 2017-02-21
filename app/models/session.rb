class Session < CDQManagedObject
  include Concerns::CDQAttributeShim

  shim_attributes!
end
