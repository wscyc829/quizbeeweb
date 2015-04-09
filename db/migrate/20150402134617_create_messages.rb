class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :room_id
      t.text :body

      t.timestamps null: false
    end

    add_index :messages, :user_id
    add_index :messages, :room_id
  end
end
