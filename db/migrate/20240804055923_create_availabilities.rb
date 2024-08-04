class CreateAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :availabilities do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.date :date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
