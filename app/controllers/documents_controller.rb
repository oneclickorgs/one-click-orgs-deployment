class DocumentsController < ApplicationController
  def index
  end

  def show
    case params[:id]
    when 'letter_of_engagement'
      send_file(File.join(Rails.root, 'data', 'pdf_form_filler', 'cuk_letter_of_engagement', 'letter_of_engagement.pdf'))
    when 'money_laundering'
      @registration_form = co
      generate_pdf('Anti-Money Laundering Form',
        :html => render_to_string(:action => 'money_laundering', :layout => false),
        :header_right => nil,
        :header_line => false,
        :stylesheet => File.join(Rails.root, 'app', 'assets', 'stylesheets', 'money_laundering.css')
      )
    end
  end
end
