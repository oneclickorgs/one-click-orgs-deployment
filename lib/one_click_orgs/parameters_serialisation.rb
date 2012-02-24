require 'one_click_orgs/parameters_hash'

module OneClickOrgs
  module ParametersSerialisation
    # Returns the (deserialized) hash of parameters for this object.
    # You can call #[]= on the returned hash and it will magically update the
    # actual parameters attribute of the object. In other words, this will
    # just work:
    # 
    # proposal.parameters[:first_name] = "Bob"
    # proposal.parameters[:first_name] # => "Bob"
    def parameters
      ParametersHash.from_hash(
        self[:parameters].blank? ? {} : ActiveSupport::JSON.decode(self[:parameters])
      ).tap do |hash|
        hash.parent = self
      end
    end
    
    def parameters=(new_parameters)
      self[:parameters] = new_parameters.blank? ? {} : new_parameters.to_json
    end
  end
end
