class AddLikesAndUnlikesColumnToMsgTable < ActiveRecord::Migration
  def change
    add_column :messages, :likes, :integer
  end
end
