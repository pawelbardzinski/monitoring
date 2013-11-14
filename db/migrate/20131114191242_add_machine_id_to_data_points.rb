class AddMachineIdToDataPoints < ActiveRecord::Migration
  def change
    add_column :data_points, :machine_id, :integer
    add_index :data_points, :machine_id
  end
end
