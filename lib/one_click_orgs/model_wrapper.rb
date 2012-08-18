require 'active_record/errors'

module OneClickOrgs
  class ModelWrapper
    extend ActiveModel::Naming
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Conversion::ClassMethods

    def initialize(attributes={})
      self.before_initialize(attributes.with_indifferent_access)
      self.attributes = attributes
      @errors = ActiveModel::Errors.new(self)
      self.after_initialize
    end

    # To massage the attributes before they are applied en-masse,
    # redefine this method in your subclass.
    def before_initialize(attributes)
    end

    # To implement custom behaviour after an instance is initialized,
    # redefine this method in your subclass.
    def after_initialize
    end

    attr_reader :errors

    def id
      @id
    end

    def persisted?
      raise NotImplementedError, "#persisted? must be implemented by subclass"
    end

    def attributes=(attributes)
      attributes.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    def update_attributes(attributes)
      self.attributes = attributes
      save
    end

    def save
      raise NotImplementedError, '#save must be implemented by subclass'
    end

    def save!
      save || raise(RecordNotSaved)
    end

    def self.find_by_id(id)
      raise NotImplementedError, '.find_by_id must be implemented by subclass'
    end

    def self.find(id)
      model_wrapper = find_by_id(id)
      raise ActiveRecord::RecordNotFound unless model_wrapper
      model_wrapper
    end

    class RecordNotSaved < ActiveRecord::RecordNotSaved
    end
  end
end
