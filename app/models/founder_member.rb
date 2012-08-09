# A convenience class to allow creation of a Member model object, but using
# 'FounderMember.new' instead of 'Member.new'.
#
# It does not do anything beyond this (for example, it does not set the member class
# automatically.)
class FounderMember < Member
  @abstract_class = true
end
