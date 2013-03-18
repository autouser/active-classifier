require 'active_support/concern'

module AttributeFor

  extend ActiveSupport::Concern

  included do   

  end

  module ClassMethods

    def attribute_for(args={})
      @foreign_class = args[:class] || _make_class_name

      self.belongs_to :foreign_class, :class_name => @foreign_class, :foreign_key => 'class_id'
    end

    def foreign_class
      @foreign_class.constantize
    end

    def _make_class_name
      self.to_s.gsub(/Attribute$/,'')
    end

  end

end