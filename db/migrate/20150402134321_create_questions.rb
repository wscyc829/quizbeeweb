class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :user_id
      t.integer :room_id
      t.text :body

      t.timestamps null: false
    end

    add_index :questions, :user_id
    add_index :questions, :room_id
  end
end
