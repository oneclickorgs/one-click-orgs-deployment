# Workaround for CVE-2015-3227
# TODO: Remove this after upgrading Rails to 4.1.11 or higher.
# https://groups.google.com/forum/#!topic/rubyonrails-security/bahr2JLnxvk
ActiveSupport::XmlMini.backend = 'Nokogiri'
