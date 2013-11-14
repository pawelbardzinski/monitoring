class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :nickname
      t.string :hostname
      t.string :user
      t.string :keys_file

      t.timestamps
    end
  end
end
