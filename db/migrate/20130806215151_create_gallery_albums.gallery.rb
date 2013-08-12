# This migration comes from gallery (originally 20130806213308)
class CreateGalleryAlbums < ActiveRecord::Migration
  def change
    create_table :gallery_albums do |t|
      t.string :name
      t.string :url
      t.text :description
      t.string :provider
      t.string :uid
      t.integer :identity_id
      t.integer :photos_count
      t.string :cover_source
      t.float :cover_aspect_ratio

      t.timestamps
    end
  end
end
