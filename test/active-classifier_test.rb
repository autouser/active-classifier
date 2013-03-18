require 'test_helper'

class ActiveClassifierTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, ActiveClassifier
  end
end
