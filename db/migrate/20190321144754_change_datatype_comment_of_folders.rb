class ChangeDatatypeCommentOfFolders < ActiveRecord::Migration[5.2]
  def change
    # コメントの文字数上限を2000文字に指定
    change_column :folders, :comment, :string, limit: 2000
  end
end
