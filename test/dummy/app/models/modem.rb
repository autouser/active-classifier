class Modem < Device

  include Classify

  attr_accessible :attr_for_modem

  classify

end
