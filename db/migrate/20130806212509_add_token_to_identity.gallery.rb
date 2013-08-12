# This migration comes from gallery (originally 20130806212451)
class AddTokenToIdentity < ActiveRecord::Migration
  def change
    add_column :gallery_identities, :token, :string
  end
end
