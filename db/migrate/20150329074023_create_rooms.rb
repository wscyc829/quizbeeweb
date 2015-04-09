class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :room_name
      t.integer :owner_id

      t.timestamps null: false
    end

    add_index :rooms, :owner_id
  end
end
