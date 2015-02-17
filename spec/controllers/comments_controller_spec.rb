require 'rails_helper'

describe CommentsController do
  
  before(:each) do
    controller.class.skip_before_filter :prepare_notifications # This filter introduses method call noise that we can ignore for this spec. 

    allow(controller).to receive(:ensure_set_up).and_return(true)
    allow(controller).to receive(:ensure_organisation_exists).and_return(true)
    allow(controller).to receive(:ensure_authenticated).and_return(true)
    allow(controller).to receive(:ensure_member_active_or_pending).and_return(true)
    allow(controller).to receive(:ensure_organisation_active).and_return(true)
    allow(controller).to receive(:ensure_member_inducted).and_return(true)
  end
  
  context "when nested in proposals" do
    describe "POST create" do
      
      let(:proposal) { mock_model(Proposal) }
      
      before(:each) do
        allow(proposal).to receive(:to_param).and_return('1')
        
        @organisation = mock_model(Organisation, :pending? => false)
        allow(controller).to receive(:co).and_return(@organisation)
      
        @proposals_association = double("proposals association")
        allow(@organisation).to receive(:proposals).and_return(@proposals_association)
      
        allow(@proposals_association).to receive(:find).and_return(proposal)
      
        @comments_association = double("comments association")
        allow(proposal).to receive(:comments).and_return(@comments_association)
      
        @comment = mock_model(Comment, :save => true, :author= => nil)
        allow(@comments_association).to receive(:build).and_return(@comment)
      
        @comment_body = "This is my comment."
      
        @member = mock_model(Member)
        allow(controller).to receive(:current_user).and_return(@member)
      end
    
      def post_create
        post :create, :proposal_id => 1, :comment => {'body' => @comment_body}
      end
    
      it "should build the comment" do
        expect(@comments_association).to receive(:build).and_return(@comment)
        post_create
      end
    
      it "should assign the author" do
        expect(@comment).to receive(:author=).with(@member)
        post_create
      end
    
      it "should assign the body" do
        expect(@comments_association).to receive(:build).with(hash_including('body' => @comment_body)).and_return(@comment)
        post_create
      end
    
      it "should save the comment" do
        expect(@comment).to receive(:save).and_return(true)
        post_create
      end
    
      it "should redirect to the proposal" do
        post_create
        expect(response).to redirect_to('/proposals/1')
      end
      
      describe "when given a sub-class of Proposal" do
        let(:proposal) { mock_model(FoundAssociationProposal) }
        
        it "should redirect to the generic Proposals controller" do
          post_create
          expect(response).to redirect_to('/proposals/1')
        end
      end
    end
  end
  
  context "when nested in meetings" do
    describe "POST create" do
      before(:each) do
        @comments_association = double("comments_association")
        @comment = mock_model(Comment, :author= => nil, :save => true).as_new_record
        allow(@comments_association).to receive(:build).and_return(@comment)
        @member = mock_model(Member)
        allow(controller).to receive(:current_user).and_return(@member)
        @meeting = mock_model(Meeting, :to_param => '1')
        @meetings_association = double("meetings association")
        @company = mock_model(Company)
        allow(controller).to receive(:co).and_return(@company)
        allow(@company).to receive(:meetings).and_return(@meetings_association)
        allow(@meetings_association).to receive(:find).with('1').and_return(@meeting)
        allow(@meeting).to receive(:comments).and_return(@comments_association)
      end
      
      def post_create
        post :create, :meeting_id => '1', :comment => {'body' => @comment_body}
      end
    
      it "should build the comment" do
        expect(@comments_association).to receive(:build).and_return(@comment)
        post_create
      end
    
      it "should assign the author" do
        expect(@comment).to receive(:author=).with(@member)
        post_create
      end
    
      it "should assign the body" do
        expect(@comments_association).to receive(:build).with(hash_including('body' => @comment_body)).and_return(@comment)
        post_create
      end
    
      it "should save the comment" do
        expect(@comment).to receive(:save).and_return(true)
        post_create
      end
    
      it "should redirect to the meeting" do
        post_create
        expect(response).to redirect_to('/meetings/1')
      end
    end
  end
  
end
