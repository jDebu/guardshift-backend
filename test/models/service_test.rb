require "test_helper"

class ServiceTest < ActiveSupport::TestCase
  def setup
    @service = services(:monitoring_service)
  end

  test "should be valid" do
    assert @service.valid?
  end

  test "name should be present" do
    @service.name = ""
    assert_not @service.valid?
  end

  test "week_start_time should be present" do
    @service.week_start_time = nil
    assert_not @service.valid?
  end

  test "week_end_time should be present" do
    @service.week_end_time = nil
    assert_not @service.valid?
  end

  test "weekend_start_time should be present" do
    @service.weekend_start_time = nil
    assert_not @service.valid?
  end

  test "weekend_end_time should be present" do
    @service.weekend_end_time = nil
    assert_not @service.valid?
  end
end
