class ChangeShiftStartTimeEndTime < ActiveRecord::Migration[7.1]
  def change
    remove_column :shifts, :start_time, :datetime
    remove_column :shifts, :end_time, :datetime
    add_column :shifts, :date, :date, null: false
    add_column :shifts, :start_time, :time, null: false
    add_column :shifts, :end_time, :time, null: false
  end
end
