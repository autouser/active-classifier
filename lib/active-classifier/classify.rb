require 'active_support/concern'

module Classify

  extend ActiveSupport::Concern

  module ClassMethods

    def classify(clsf = true, args = {})

      ActiveClassifier.register_class(self, clsf)

      self.inheritance_queue do |cls, at|
        next unless at

        attr_accessible *self.field_names_for_class.collect(&:to_sym)

        self.has_one "attr_for_#{cls.to_s.underscore}".to_sym, 
          :class_name => "#{cls.to_s}Attribute",
          :foreign_key => 'class_id',
          :dependent => :destroy,
          :autosave => true
      end

      parent_node = self.inheritance_array.collect(&:to_s)
      child_node = parent_node.pop

      ActiveClassifier.add_class_node(parent_node, child_node)
    end

    def attributes_class
      classified? ? "#{self.to_s}Attribute".constantize : nil
    end


    def classified=(value)
      ActiveClassifier.register_class(self,value)
    end

    def classified?
      ActiveClassifier.classified?(self)
    end

    def inheritance_array
      res = []
      res << self.superclass.inheritance_array if self.superclass && ActiveClassifier.classified.key?(self.superclass.to_s)
      res << [self]
      res.flatten
    end

    def inheritance_queue(reverse = true)
      a = self.inheritance_array
      a = a.reverse if reverse
      a.each {|cls| yield(cls, cls.classified?) if block_given? }
      nil
    end

    def inheritance_path(separator='.')
      self.inheritance_array.collect {|cls| cls.to_s.underscore}.join(separator)
    end

    def all_class_relations
      self.inheritance_array.collect {|cls| cls.class_relation}.compact
    end

    def class_relation
      self.classified? ? "attr_for_#{self.to_s.underscore}".to_s : nil
    end

    def class_for_field(field_name)
      self.inheritance_queue do |cls, at|
        return cls if cls.columns_hash.key?(field_name.to_s)
        return cls.attributes_class if at && cls.attributes_class.columns_hash.key?(field_name.to_s)
      end
    end

    def relation_for_field(field_name)
      self.inheritance_queue do |cls, at|
        return cls.class_relation if at && field_name.to_s != 'class_id' && cls.attributes_class.columns_hash.key?(field_name.to_s)
      end
    end


    def field_names_for_class
      flds = []

      self.inheritance_queue do |cls, at|
          flds.push(cls.column_names)
          flds.push([cls.attributes_class.column_names.reject {|n| n == 'class_id' || n == 'id'}]) if at
      end

      flds.flatten.uniq
    end

    def fields_for_class
      shared, flds = [], []

      self.inheritance_queue do |cls, at|
          shared = (shared+cls.classified_fields).uniq
          flds.push([cls.class_relation, cls.attributes_class.classified_fields]) if at
      end

      flds.unshift(shared)
    end

    def classified_fields
      self.columns.reject {|c| c.name == 'class_id' || c.name == 'id' }.collect do |column|
        {:name => column.name, :type => column.type}
      end
    end

    def includes_class
      self.includes(*self.all_class_relations.collect(&:to_sym))
    end

  end

  def method_missing(method_name, *args, &block)
    match_data = method_name.to_s.match(/^(\w+)(|=)$/)

    if match_data && rel = self.class.relation_for_field(match_data[1])
      attrs = self.send(rel) || self.send("build_#{rel.to_s}")
      raise "#{rel} was not built" if attrs.nil?
      attrs.send(method_name, *args)
    else
      super(method_name, *args, &block)
    end

  end

  def respond_to?(name, *args)
    name.to_s =~ /^(\w+)(|=)$/

    return true if self.class.field_names_for_class.include?($1)

    super(name, *args)
  end

  def inheritance_path(separator='.')
    self.class.inheritance_path(separator)
  end

end

ActiveRecord::Base.send :include , Classify