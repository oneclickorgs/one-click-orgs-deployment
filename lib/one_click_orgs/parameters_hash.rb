# A light wrapper around Hash that can retain a reference to a parent object.
# The reference is used to update the actual parameters attribute of the
# parent when the parameters hash is naively updated by calling #[]= on
# it.
class ParametersHash < Hash
  attr_accessor :parent
  
  # Returns a new ParametersHash with the contents of the given hash.
  def self.from_hash(hash)
    hash ? new.replace(hash) : new
  end
  
  def []=(key, value)
    parent.parameters = parent.parameters.merge({key => value})
    super
  end
end
