class CreateCommentsTable < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.integer :message_id
      t.string :comments
    end
  end

  def down
    drop_table :comments
  end
end
