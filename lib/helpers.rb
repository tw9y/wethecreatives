helpers do
  
  def page_title
    case
      when @post
        @post.title + " - We the Creatives"
      else
        "We the Creatives"
    end
  end
    
  def link_to_post (post, label = nil)
    label ||= post.title
    "<a href=\"/#{post.slug}\">#{label}</a>"
  end
  
  def image_tag (image_url)
    "<img src=\"#{image_url}\" />" unless image_url == ""
  end
  
  def time_ago(date)
    date.strftime("%Y-%m-%d")
  end

  def text_to_html (text, args = {})
      args = { :emotes => true, :map_headings => 2 }.merge args

      html = Moredown.text_to_html(text, args)
      html.gsub!(/<pre><code>#! (.*?)\n([^<]*?)<\/code><\/pre>/) { |match| "<pre><code class=\"#{$1.downcase.strip}\">#{$2.strip}</code></pre>" }

      if args[:teaser]
        paragraphs = html.scan(/<p.*?p>/)
        # ignore the first paragraph if it contains only an image
        if paragraphs.first =~ /<p><img.+?\/><\/p>/ or paragraphs.first =~ /<p><object.+?<\/object><\/p>/
          teaser = paragraphs[1]
        else
          teaser = paragraphs.first
        end

        if teaser != nil and teaser != html.strip and args[:slug]
          teaser += "<p class=\"read_more\"><a href=\"/#{args[:slug]}\">#{Site.read_more_text}</a></p>"
          html = teaser
        end
      end

      html
    end
  
  def tags (tags)
    tags = [tags] if tags.is_a? String

    tags = tags.collect do |tag| 
      if tags.size > 1
        if tag == tags.last
          suffix = ''
        else
          suffix = ','
        end
      end
      "<li><a href=\"/tags/#{tag}\">#{tag}</a>#{suffix}</li>"
    end
    "<ul>#{tags.join(' ')}</ul>"
  end
  
  def content_for(key, &block)
    content_blocks[key.to_sym] << block
  end
  
  def yield_content(key, *args)
    content_blocks[key.to_sym].map do |content| 
      content.call(*args)
    end.join
  end

  private

  def content_blocks
    @content_blocks ||= Hash.new {|h,k| h[k] = [] }
  end

  # Render a partial template
  # 
  # eg.
  #   partial :posts => @posts
  #   partial :post => post
  def partial (template, options = {})
    options = { :layout => false }.merge options
    if template.is_a? Hash
      options[:locals] = template[:locals] || {}
      template.delete(:locals) if template[:locals]      
      options[:locals].merge! template
      template = template.reject{ |key, value| [:locals].include? key }.keys.first.to_s
    end    
    erb("_#{template}".to_sym, options)
  end
  
  # Render links to the next and previous things
    def where_to_now? (relative_to)
      if relative_to.class == Post
        newer_post = Post.previous_before(relative_to)
        older_post = Post.next_after(relative_to)

        newer_post = (newer_post)? "#{link_to_post(newer_post)} is next" : "<span>Nothing is next</span>"
        older_post = (older_post)? "Previously, #{link_to_post(older_post)}" : "<span>Previously, nothing</span>"
        options = "<ul><li>#{newer_post}</li><li>#{older_post}</li></ul>"
      else # page number
        older_posts = (Post.page(relative_to + 1).empty?)? "<span>No older posts</span>" : "<a href=\"/?page=#{relative_to + 1}\">Older posts</a>"
        newer_posts = (relative_to > 1)? "<a href=\"/?page=#{relative_to - 1}\">Newer posts</a>" : "<span>No newer posts</span>"
        options = "<ul><li class=\"older_posts\">#{older_posts}</li><li class=\"newer_posts\">#{newer_posts}</li></ul>"
      end

      options
    end
  
end