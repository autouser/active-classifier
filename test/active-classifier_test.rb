require 'test_helper'

class ActiveClassifierTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, ActiveClassifier
  end

  test "class_tree" do
    assert_equal ({"Item"=>{"Device"=>{"Modem"=>{"DummyModem"=>{"Telsey"=>{}}}}}}), ActiveClassifier.class_tree, "should register class_tree"
  end

end
