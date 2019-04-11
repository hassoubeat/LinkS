class ChangeDatatypeUrlOfLinks < ActiveRecord::Migration[5.2]
  def change
    # URLの文字数上限を2000文字に指定
    change_column :links, :url, :string, limit: 2000
  end
end
