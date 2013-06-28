# require 'haml/filters'
# require 'rdiscount'

# module Haml
#   module Filters
#     # Override Haml's built-in Markdown filter to add escaping of raw HTML.
#     module Markdown
#       def render(text)
#         ::RDiscount.new(text, :filter_html).to_html.html_safe
#       end
#     end
#   end
# end
