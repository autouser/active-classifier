require 'active_support/concern'

module Classify

  extend ActiveSupport::Concern

  module ClassMethods

    def classify(clsf=true, args={})
      @classified = clsf
      self.inheritance_queue do |cls, at|
        if at
          self.has_one "attr_for_#{cls.to_s.underscore}".to_sym, :class_name => "#{cls.to_s}Attribute", :foreign_key => 'class_id', :dependent => :destroy
        end
      end
    end

    def attributes_class
      classified? ? "#{self.to_s}Attribute".constantize : nil
    end


    def classified=(value)
      @classified=value
    end

    def classified?
      @classified
    end

    def inheritance_array
      res = []
      res << self.superclass.inheritance_array if self.superclass.respond_to?(:classified?)
      res << [self]
      res.flatten
    end

    def inheritance_queue(reverse=true, &block)
      a = self.inheritance_array
      a = a.reverse if reverse
      a.each do |cls|
        yield(cls, cls.classified?)
      end
    end

    def all_relations
      self.inheritance_array.collect {|cls| cls.cls_relation}.compact
    end

    def cls_relation
      self.classified? ? "attr_for_#{self.to_s.underscore}".to_s : nil
    end

    def class_for_field(field_name)
      self.inheritance_queue do |cls, at|
        return cls if cls.columns_hash.key?(field_name.to_s)
        return cls.attributes_class if at && cls.attributes_class.columns_hash.key?(field_name.to_s)
      end
      return nil
    end

    def fields_for_class
      shared = []
      flds = []
      self.inheritance_queue do |cls, at|
          shared = (shared+cls.column_names).uniq
          flds.push([cls.cls_relation, cls.attributes_class.column_names]) if at
      end
      return flds.unshift(shared)
    end

    def includes_class
      
    end

  end

end