# This migration comes from gallery (originally 20130806221405)
class AddPublicToAlbum < ActiveRecord::Migration
  def change
    add_column :gallery_albums, :public, :boolean, default: false
  end
end
