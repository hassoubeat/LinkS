class AddAuthorityToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :authority, :string
  end
end
