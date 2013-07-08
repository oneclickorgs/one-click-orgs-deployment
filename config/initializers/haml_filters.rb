require 'haml/filters'
require 'rdiscount'

Haml::Filters.remove_filter("Markdown")

module Haml
  module Filters
    # Override Haml's built-in Markdown filter to add escaping of raw HTML.
    module Markdown
      include Base

      def render_with_options(text, options)
        ::RDiscount.new(text, :filter_html).to_html.html_safe
      end
    end
  end
end
