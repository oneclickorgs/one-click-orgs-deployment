module ConstitutionsHelper
  def edit_form(&block)
    if @constitution_wrapper
      form_for(@constitution_wrapper, {:as => :constitution, :url => constitution_path, :method => :put}, &block)
    elsif @constitution_proposal_bundle
      form_for(@constitution_proposal_bundle, &block)
    else
      raise RuntimeError, "model object not set up"
    end
  end
end
