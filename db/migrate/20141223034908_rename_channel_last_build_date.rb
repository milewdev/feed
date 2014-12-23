class RenameChannelLastBuildDate < ActiveRecord::Migration
  def change
    rename_column :channels, :lastBuildDate, :last_build_date
  end
end
