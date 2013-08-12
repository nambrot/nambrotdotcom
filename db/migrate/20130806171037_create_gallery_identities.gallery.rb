# This migration comes from gallery (originally 20130806170912)
class CreateGalleryIdentities < ActiveRecord::Migration
  def change
    create_table :gallery_identities do |t|
      t.string :uid
      t.string :provider
      t.string :name
      t.string :link

      t.timestamps
    end
  end
end
