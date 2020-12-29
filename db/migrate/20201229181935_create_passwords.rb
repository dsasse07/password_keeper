class CreatePasswords < ActiveRecord::Migration[5.2]
  def change
    create_table :passwords do |t|
      t.integer :group_service_id
      t.string :password
      t.boolean :current
      t.timestamps
    end
  end
end
