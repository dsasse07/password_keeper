class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.integer :group_id
      t.string :name
      t.string :required_access
      t.string :service_username
      t.timestamps
    end
  end
end
