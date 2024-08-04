class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.string :name
      t.time :week_start_time
      t.time :week_end_time
      t.time :weekend_start_time
      t.time :weekend_end_time

      t.timestamps
    end
  end
end
