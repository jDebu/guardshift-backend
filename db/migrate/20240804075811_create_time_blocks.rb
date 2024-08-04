class CreateTimeBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :time_blocks do |t|
      t.references :blockable, polymorphic: true, null: true
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end
  end
end
