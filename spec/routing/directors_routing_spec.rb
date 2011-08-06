require 'spec_helper'

describe "routing to directors" do
  it "routes POST /directors/1/stand_down to directors#stand_down" do
    {:post => '/directors/1/stand_down'}.should route_to(
      :controller => 'directors',
      :action => 'stand_down',
      :id => '1'
    )
  end
end
