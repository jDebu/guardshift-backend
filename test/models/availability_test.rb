require "test_helper"

class AvailabilityTest < ActiveSupport::TestCase
  fixtures :all

  def setup
    @availability = availabilities(:jose_delgado_availability)
  end

  test "should be valid" do
    assert @availability.valid?
  end

  test "employee should be present" do
    @availability.employee = nil
    assert_not @availability.valid?
  end

  test "service should be present" do
    @availability.service = nil
    assert_not @availability.valid?
  end

  test "date should be present" do
    @availability.date = nil
    assert_not @availability.valid?
  end

  test "start_time should be present" do
    @availability.start_time = nil
    assert_not @availability.valid?
  end

  test "end_time should be present" do
    @availability.end_time = nil
    assert_not @availability.valid?
  end

end
