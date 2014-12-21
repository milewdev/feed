class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.string :title
      t.string :guid

      t.timestamps null: false
    end
    add_index :feed_items, :guid, unique: true
  end
end
