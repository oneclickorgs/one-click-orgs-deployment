class DocumentsController < ApplicationController
  def index
  end

  def show
    case params[:id]
    when 'letter_of_engagement'
      send_file(File.join(Rails.root, 'data', 'pdf_form_filler', 'cuk_letter_of_engagement', 'letter_of_engagement.pdf'))
    end
  end
end
