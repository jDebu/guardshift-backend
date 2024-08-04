require "test_helper"

class ShiftTest < ActiveSupport::TestCase
  fixtures :all

  def setup
    @shift = shifts(:jose_delgado_shift)
  end

  test "should be valid" do
    assert @shift.valid?
  end

  test "employee should be present" do
    @shift.employee = nil
    assert_not @shift.valid?
  end

  test "service should be present" do
    @shift.service = nil
    assert_not @shift.valid?
  end

  test "date should be present" do
    @shift.date = nil
    assert_not @shift.valid?
  end

  test "start_time should be present" do
    @shift.start_time = nil
    assert_not @shift.valid?
  end

  test "end_time should be present" do
    @shift.end_time = nil
    assert_not @shift.valid?
  end
end
