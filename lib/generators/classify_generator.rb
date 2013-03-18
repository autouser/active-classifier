require 'pp'
class ClassifyGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  argument :class_name, :type => :string, :required => true
  argument :parent_class_name, :type => :string, :required => false
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

  def classify
    pp class_name
    pp parent_class_name
    pp behavior
    invoke "active_record:model", 'class_name'
  end

end