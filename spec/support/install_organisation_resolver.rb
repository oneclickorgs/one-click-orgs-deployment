# This is an altered version of the #install_organisation_resolver
# method in ApplicationController proper. It is necessary in order
# for RSpec's controller specs to work. RSpec introduces a custom
# resolver, RSpec::Rails::ViewRendering::PathSetDelegatorResolver,
# in order to exercise controller actions without actually rendering
# views. However, PathSetDelegatorResolver is incompatible with the
# way we create our custom OrganisationResolvers based on standard
# ActionView resolvers. This altered method creates
# OrganisationResolvers based on PathSetDelegatorResolvers instead,
# when it encounters them.

require 'rspec/rails/view_rendering'
require 'one_click_orgs/organisation_resolver'
require 'action_view/paths'

class ApplicationController < ActionController::Base
  def install_organisation_resolver_with_rspec_workaround(organisation)
    if view_paths.length == 1 && view_paths[0].respond_to?(:path_set)
      path_set_delegator_resolver = view_paths[0]
      original_path_set = path_set_delegator_resolver.path_set
      
      new_path_set = original_path_set.dup
      
      new_path_set.unshift(*original_path_set.reverse.map{|p| OneClickOrgs::OrganisationResolver.new(p.to_path, organisation.class)})
      
      new_path_set_delegator_resolver = RSpec::Rails::ViewRendering::PathSetDelegatorResolver.new(view_paths)
      
      self.class.view_paths = ActionView::PathSet.new.push(new_path_set_delegator_resolver)
    else
      install_organisation_resolver_without_rspec_workaround(organisation)
    end
  end
  alias_method_chain :install_organisation_resolver, :rspec_workaround
end
