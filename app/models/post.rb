class Post

  attr_accessor :id, :title, :summary, :categories, :created_at

  def initialize(id, title, summary, categories, created_at)
    @id = id
    @title = title
    @summary = summary
    @categories = categories
    @created_at = DateTime.parse(created_at)
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def body
    @body ||= File.read("#{Rails.root.to_s}/posts/#{id}.md")
  end

  def self.all
    @posts ||=
      YAML
        .load_file("#{Rails.root.to_s}/posts/all.yaml")
        .map { |h| Post.new(h['id'], h['title'], h['summary'], h['tags'], h['created_at']) }
        .sort_by { |post| -post.created_at.to_i }
  end

  def to_partial_path
    'posts/post'
  end

  def persisted?
    true
  end
end
