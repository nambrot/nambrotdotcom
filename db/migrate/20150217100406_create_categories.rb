class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    add_index :categories, :name, unique: true

    create_table :blog_posts_categories do |t|
      t.integer :post_id
      t.integer :category_id
    end

    add_index :blog_posts_categories, [:post_id, :category_id], unique: true
  end
end
