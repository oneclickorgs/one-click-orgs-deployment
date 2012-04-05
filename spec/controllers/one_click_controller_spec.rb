require 'spec_helper'

describe OneClickController do
  
  describe "GET dashboard" do
    before(:each) do
      controller.class.skip_before_filter :prepare_notifications # This filter introduses method call noise that we can ignore for this spec. 

      controller.stub(:ensure_set_up).and_return(true)
      controller.stub(:ensure_organisation_exists).and_return(true)
      controller.stub(:ensure_authenticated).and_return(true)
      controller.stub(:ensure_member_active).and_return(true)
      controller.stub(:ensure_organisation_active).and_return(true)
      controller.stub(:ensure_member_inducted).and_return(true)
      
      @organisation = mock_model(Organisation, :pending? => false, :proposed? => false)
      controller.stub(:current_organisation).and_return(@organisation)
      controller.stub(:co).and_return(@organisation)
      
      @organisation.stub_chain(:proposals, :currently_open).and_return([])
      @organisation.stub_chain(:proposals, :new).and_return(mock_model(Proposal))
      @organisation.stub_chain(:members, :new).and_return(mock_model(Member))
      @organisation.stub(:default_member_class).and_return(mock_model(MemberClass))
      
      @organisation.stub_chain(:members, :all).and_return([])
      @organisation.stub_chain(:proposals, :all).and_return([])
      @organisation.stub_chain(:decisions, :all).and_return([])
    end
    
    describe "timeline" do
      before(:each) do
        @resignation_event = mock('resignation event')
        @organisation.stub_chain(:resignations, :all).and_return(mock_model(Resignation,
          :to_event => @resignation_event
        ))
      end
      
      it "includes Resignation events" do
        get_dashboard
        assigns[:timeline].should include(@resignation_event)
      end
    end
    
    def get_dashboard
      get :dashboard
    end
  end
  
end
