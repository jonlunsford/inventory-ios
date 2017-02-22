class Session < CDQManagedObject
  include Concerns::CDQAttributeShim

  if App.development? || App.test?
    def token
      getter(__method__.to_s)
    end

    def token=(value)
      setter(__method__.to_s, value)
    end
  end
end
