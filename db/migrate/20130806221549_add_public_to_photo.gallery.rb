# This migration comes from gallery (originally 20130806221438)
class AddPublicToPhoto < ActiveRecord::Migration
  def change
    add_column :gallery_photos, :public, :boolean, default: true
  end
end
