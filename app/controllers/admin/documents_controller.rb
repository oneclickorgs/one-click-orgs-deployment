class Admin::DocumentsController < AdminController

  def show
    case params[:id]
    when 'money_laundering'
      respond_to do |format|
        format.pdf do
          @registration_form = Coop.find(params[:coop_id])
          html = render_to_string(:template => 'documents/money_laundering', :layout => false, :formats => [:html])
          generate_pdf('Anti-Money Laundering Form',
            :html => html,
            :organisation => @registration_form,
            :header_right => nil,
            :header_line => false,
            :stylesheet => File.join(Rails.root, 'app', 'assets', 'stylesheets', 'money_laundering.css')
          )
        end
      end
    else
      render_404
    end
  end

end
