class Admin::MembersController < AdminController
  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member])
      flash[:success] = "Member details updated."
      redirect_to(admin_coop_path(@member.organisation))
    else
      render(:action => :edit)
    end
  end
end
