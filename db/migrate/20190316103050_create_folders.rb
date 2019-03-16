class CreateFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :folders do |t|
      t.string :name
      t.string :comment
      t.integer :sort
      t.boolean :is_valid
      t.boolean :is_open
      t.integer :user_id

      t.timestamps
    end
  end
end
