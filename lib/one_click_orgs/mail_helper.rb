# encoding: UTF-8

require 'mail/elements/address'

module OneClickOrgs
  module MailHelper
    # Construct a well-formed 'name-address' from a display name and an address.
    # 
    # name_addr('Bob Smith', 'bob@example.com') # => "Bob Smith <bob@example.com>"
    def name_addr(display_name, address)
      a = Mail::Address.new
      a.display_name = display_name
      a.address = address
      a.format
    end
    module_function :name_addr

    def cleaned_subject(subject)
      # Remove non-ASCII characters
      subject.gsub!(/\P{ASCII}/, '')
      # Remove carriage returns and line feeds
      subject.gsub!(/(\r|\n)/, ' ')
      subject
    end
    module_function :cleaned_subject
  end
end
