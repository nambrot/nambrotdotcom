module ApplicationHelper

  def format_markdown(content)
    renderer = Redcarpet::Render::HTML
    Redcarpet::Markdown.new(renderer).render(content).html_safe
  end

  def field(content_or_options={}, options ={}, &block)
    div_with_default_class(:field, content_or_options, options, &block)
  end

  def div_with_default_class(default_class, content_or_options={}, options={}, &block)
    if block_given?
      content = capture(&block)
      options = content_or_options
    else
      content = content_or_options
    end
    options[:class] = "#{default_class} #{options[:class]}".strip
    content_tag(:div, content, options)
  end
end
