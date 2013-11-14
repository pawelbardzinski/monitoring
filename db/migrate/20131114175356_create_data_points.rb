class CreateDataPoints < ActiveRecord::Migration
  def change
    create_table :data_points do |t|
      t.float :cpu_usage
      t.float :mem_usage

      t.timestamps
    end
  end
end
