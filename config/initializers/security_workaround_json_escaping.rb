# Workaround for CVE-2015-3226
# TODO: Remove this after upgrading to Rails 4.1.11 or higher.
# https://groups.google.com/forum/#!topic/ruby-security-ann/7VlB_pck3hU
module ActiveSupport
  module JSON
    module Encoding
      private
      class EscapedString
        def to_s
          self
        end
      end
    end
  end
end
