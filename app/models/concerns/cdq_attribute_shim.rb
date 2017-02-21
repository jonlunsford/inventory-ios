# As of XCode 8.2, compiling an NSManagedObject (usually through CDQ's CDQManagedObject), will cause
# attributes to throw the following warning:
#   CoreData: warning: dynamic accessors failed to find @property implementation for 'name' for
#   entity Note while resolving selector 'name' on class 'Note'.  Did you remember to
#   declare it @dynamic or @synthesized in the @implementation?
#
# Since the CoreData accessors are generated dynamically, the attributes should be
# designated with @dynamic:
# http://stackoverflow.com/questions/1160498/synthesize-vs-dynamic-what-are-the-differences
#
# By implementing the accessors ourselves, we silence the warning and maintain functionality.
# http://stackoverflow.com/questions/21997299/how-to-access-instance-variables-of-synthesized-properties-from-a-vendored-class
#
# Also consider using `if App.development? || App.test?` to only use the shim in dev/test
#------------------------------------------------------------------------------
module Concerns
  module CDQAttributeShim
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def shim_attributes!
        self.attribute_names.each do |attr|
          if App.development? || App.test?
            define_method(attr) do
              getter(__method__.to_s)
            end

            define_method("#{attr}=") do |value|
              setter(__method__.to_s, value)
            end
          end
        end
      end
    end

    # use this retrieve a value for an attribute.  In order to access the underlying
    # private variable, the attribute name needs to be capitalized.
    # so `publishedAt` ==> `primitivePublishedAt`
    def getter(attribute)
      willAccessValueForKey(attribute)
      value = send("primitive#{attribute.sub(/\S/, &:upcase)}")
      didAccessValueForKey(attribute)
      return value
    end

    # use this to set the value of an attribute
    # '=' should already be appended to attribute name, such as `publishedAt=`
    def setter(attribute, value)
      willChangeValueForKey(attribute)
      send("primitive#{attribute.sub(/\S/, &:upcase)}", value)
      didChangeValueForKey(attribute)
      return value
    end

  end
end


# add the proper include and setter/getter for each attribute in each model, as in the
# example below
# note: we have to define each attribute individually.  if we try to use
# `define_method`, then we'll get an error like this:
#   <Author_Author_ 0x109c317c0> method `name' created by attr_reader/writer or define_method
#   cannot be called from Objective-C. Please manually define the method instead (using the `def' keyword)
#------------------------------------------------------------------------------
# class Note < CDQManagedObject
#   include Concerns::CDQAttributeShim
#
#   if App.development? || App.test?
#     def name
#       getter(__method__.to_s)
#     end
#     def name=(value)
#       setter(__method__.to_s, value)
#     end
#   end
#
# end
