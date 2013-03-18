class DeviceAttribute < ActiveRecord::Base

  include AttributeFor

  attr_accessible :class_id, :issued_at, :vendor

  attribute_for

end
