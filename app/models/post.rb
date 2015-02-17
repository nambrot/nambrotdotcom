class Post < ActiveRecord::Base
  self.table_name = "blog_posts"

  validates :title, presence: true, length: { minimum: 10, maximum: 66 }
  validates :summary,  presence: true, length: { minimum: 10 }
  validates :body,  presence: true, length: { minimum: 10 }
  validates :blogger_id, presence: true

  belongs_to :blogger, :polymorphic => true

  def to_param
    "#{id}-#{title.parameterize}"
  end
end