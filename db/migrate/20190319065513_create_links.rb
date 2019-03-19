class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.string :name
      t.string :url
      t.string :comment
      t.string :skin_type
      t.integer :sort
      t.boolean :is_valid
      t.integer :user_id
      t.integer :folder_id

      t.timestamps
    end
  end
end
