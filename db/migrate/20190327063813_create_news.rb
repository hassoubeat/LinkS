class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.string :title, limit: 200
      t.string :content, limit: 2000
      t.string :skin_type
      t.boolean :is_valid
      t.integer :user_id

      t.timestamps
    end
  end
end
