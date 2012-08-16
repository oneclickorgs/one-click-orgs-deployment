# Represents a single 'ballot paper' in an election. To vote, a member
# ranks any number of nominees in order of preference.
#
# This ranking is stored in the attribute 'ranking', as an array of
# Nomination IDs.
class Ballot < ActiveRecord::Base
  attr_protected

  serialize :ranking, Array

  belongs_to :member

  def ranking
    self[:ranking] ||= []
  end

  def method_missing(name, *args, &block)
    if name.to_s.match(/\Aranking_\d+=?\Z/)
      handle_ranking_method(name, *args)
    else
      super
    end
  end

  def respond_to?(name, include_priv=false)
    if name.to_s.match(/\Aranking_\d+=?\Z/)
      true
    else
      super
    end
  end

  def handle_ranking_method(name, *args)
    if name.to_s.match(/=\Z/)
      handle_ranking_setter_method(name, *args)
    else
      handle_ranking_getter_method(name, *args)
    end
  end

  def handle_ranking_setter_method(name, *args)
    nomination_id = name.to_s.match(/\Aranking_(.*?)=\Z/)[1].to_i
    ranking_position = args[0]

    unless ranking_position.blank?
      self.ranking[ranking_position.to_i - 1] = nomination_id
    end

    ranking_position
  end

  def handle_ranking_getter_method(name, *args)
    nomination_id = name.to_s.match(/\Aranking_(.*?)\Z/)[1].to_i

    self.ranking.find_index(nomination_id)
  end
end
