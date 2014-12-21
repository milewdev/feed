class CreateRssItem < ActiveRecord::Migration
  def change
    create_table :rss_items do |t|
      t.string :title
      t.string :guid
      t.timestamps null: false
    end
    add_index :rss_items, :guid
  end
end
