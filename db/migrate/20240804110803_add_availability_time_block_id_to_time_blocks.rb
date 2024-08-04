class AddAvailabilityTimeBlockIdToTimeBlocks < ActiveRecord::Migration[7.1]
  def change
    add_reference :time_blocks, :availability_time_block, foreign_key: { to_table: :time_blocks }, null: true
  end
end
