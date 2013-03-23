module ActiveClassifier

  @class_tree = {}

  def self.class_tree
    @class_tree
  end

  def self.class_tree=(tree={})
    @class_tree = tree
  end

  def self.add_class_node(parent_node, child_node_name)
    self.get_class_node(parent_node)[child_node_name] = {}
  end

  def self.get_class_node(path = [], node = nil)
    return @class_tree if node.nil? && path.empty?

    node = @class_tree if node.nil? && ! path.empty?
    name = path.shift

    if ! name.nil? && path.empty?
      node[name]
    else
      self.get_class_node(path,node[name])
    end
  end

  # Preloads all models. Useful in development mode
  def self.preload_models
    Dir[Rails.root + 'app/models/*.rb'].map {|f| File.basename(f, '.*').camelize.constantize }
  end

end


require 'active-classifier/classify'
require 'active-classifier/attribute_for'

