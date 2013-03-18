class TelseyAttribute < ActiveRecord::Base

  include AttributeFor

  attr_accessible :mac

  attribute_for

end
