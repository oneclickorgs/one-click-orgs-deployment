require 'pdf-reader'

Then(/^the PDF should contain "(.*?)"$/) do |text|
  reader = PDF::Reader.new(StringIO.new(page.source, 'rb'))
  content = reader.pages.map(&:text).join(' ')
  expect(content).to include(text)
end
