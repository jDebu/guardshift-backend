require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  def setup
    @employee = employees(:jose_delgado)
  end

  test "should be valid" do
    assert @employee.valid?
  end

  test "name should be present" do
    @employee.name = ""
    assert_not @employee.valid?
  end

  test "color should be present" do
    @employee.color = ""
    assert_not @employee.valid?
  end
end
