class Item < ActiveRecord::Base

  include Classify

  attr_accessible :name, :type

  classify false

end
