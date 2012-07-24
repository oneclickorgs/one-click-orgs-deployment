module OneClickOrgs
  module CastToBoolean
    
  protected
    
    # Attempts to turn strings like 'true', 'false', '1', '0' into
    # an actual boolean value.
    def cast_to_boolean(value)
      if value == 'true'
        true
      elsif value == 'false'
        false
      elsif value.respond_to?(:to_i)
        if value.to_i == 1
          true
        elsif value.to_i == 0
          false
        end
      else
        !!value
      end
    end

  end
end
