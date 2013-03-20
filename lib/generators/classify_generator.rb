require 'rails/generators/active_record'
require 'rails/generators/migration'

class ClassifyGenerator < Rails::Generators::Base

  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  argument :class_name, :type => :string, :required => true
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

  class_option :parent, :type => :string, :desc => 'parent class', :default => nil
  class_option :classify, :type => :boolean, :desc => 'is class have additional attributes?', :default => true

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def process_attributes
    @class_attributes = []
    @additional_attributes = []
    unless attributes.empty?
      attributes.each do |attribute|
        a = attribute.split(':')
        if a[0] == 'attr'
          @additional_attributes << {:name => a[1], :type => a[2] }
        else
          @class_attributes << {:name => a[0], :type => a[1] }
        end
      end
    end
    @additional_attributes.unshift({:name => 'class_id', :type => 'integer'}) if @additional_attributes.count{|a| a[:name] == 'class_id'} == 0

  end

  def process_classify_macro
    @macro = options[:classify] ? "classify" : "classify false"
  end

  def process_migraetion_data

  end

  def classify
    template "class.erb", "app/models/#{class_name.underscore}.rb"
    migration_template "class_migration.erb", "db/migrate/create_#{class_name.underscore.gsub('/','_').pluralize}"
    template "attr_class.erb", "app/models/#{class_name.underscore}_attribute.rb"
    migration_template "attr_class_migration.erb", "db/migrate/create_#{"#{class_name}Attribute".underscore.gsub('/','_').pluralize}"
  end

end