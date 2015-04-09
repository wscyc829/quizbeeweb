class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :question_id
      t.text :body

      t.timestamps null: false
    end

    add_index :comments, :user_id
    add_index :comments, :question_id
  end
end
