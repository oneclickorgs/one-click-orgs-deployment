# This is an altered version of the #install_organisation_resolver
# method in ApplicationController proper. It is necessary in order
# for RSpec's controller specs to work. RSpec introduces a custom
# resolver, RSpec::Rails::ViewRendering::EmptyTemplatePathSetDecorator,
# in order to exercise controller actions without actually rendering
# views. However, EmptyTemplatePathSetDecorator is incompatible with the
# way we create our custom OrganisationResolvers based on standard
# ActionView resolvers. This altered method creates
# OrganisationResolvers wrapped in an EmptyTemplatePathSetDecorator instead,
# when it encounters one.

require 'rspec/rails/view_rendering'
require 'one_click_orgs/organisation_resolver'
require 'action_view/path_set'

class ApplicationController < ActionController::Base
  def install_organisation_resolver_with_rspec_workaround(organisation)
    if view_paths[0].respond_to?(:original_path_set)
      empty_template_path_set_decorator = view_paths[0]
      original_path_set = empty_template_path_set_decorator.original_path_set
      
      new_path_set = original_path_set.dup
      
      new_path_set.unshift(*original_path_set.map{|p| OneClickOrgs::OrganisationResolver.new(p.to_path, organisation.class)})

      new_empty_template_path_set_decorator = RSpec::Rails::ViewRendering::EmptyTemplatePathSetDecorator.new(new_path_set)
      lookup_context.view_paths = ActionView::PathSet.new.push(new_empty_template_path_set_decorator)
    else
      install_organisation_resolver_without_rspec_workaround(organisation)
    end
  end
  alias_method_chain :install_organisation_resolver, :rspec_workaround
end
