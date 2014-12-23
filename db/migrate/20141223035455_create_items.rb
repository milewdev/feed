class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :link
      t.string :comments
      t.datetime :pub_date
      t.string :guid
      t.string :description
      t.references :channel, index: true

      t.timestamps null: false
    end
    add_foreign_key :items, :channels
  end
end
