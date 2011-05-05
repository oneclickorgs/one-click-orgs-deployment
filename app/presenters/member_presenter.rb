class MemberPresenter
  def initialize(member)
    self.member = member
  end
  
  attr_accessor :member
  
  def timeline
    @timeline ||= [
      @member,
      @member.proposals.all,
      @member.votes.all
    ].flatten.map(&:to_event).compact.sort{|a, b| b[:timestamp] <=> a[:timestamp]}
  end
end
