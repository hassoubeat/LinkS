class AddIsOpenToNews < ActiveRecord::Migration[5.2]
  def change
    add_column :news, :is_open, :boolean
  end
end
