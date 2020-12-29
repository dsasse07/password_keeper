class CreateGroupServices < ActiveRecord::Migration[5.2]
  def change
    create_table :group_services do |t|
      t.integer :group_id
      t.integer :service_id
      t.string :required_access
      t.string :service_username
      t.timestamps
    end
  end
end
