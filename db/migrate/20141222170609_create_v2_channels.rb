class CreateV2Channels < ActiveRecord::Migration
  def change
    create_table :v2_channels do |t|
      t.string :title
      t.string :link
      t.string :description
      t.datetime :lastBuildDate
      t.string :language
      t.string :generator

      t.timestamps null: false
    end
  end
end
