class Post < Maneki
  path 'posts'
  
  def self.page (n, per_page = 5)
    n = 1 unless n
    start = (n.to_i - 1) * per_page

    return [] if start >= all.size

    finish = start + per_page
    finish = all.size if finish > all.size

    all.sort[start...finish]
  end
  
  # if the post is just a link
  def link
    @headers[:link]
  end
  
  def tags
    tags = @headers[:tags] ||= []
  end
  
  def tagline
    tagline = @headers[:tagline] || ""
  end
  
  def author
    author = @headers[:author] || ""
  end
  
  def published_at
    Time.parse(@headers[:published_at]) if @headers[:published_at]
  end
  
  def opening_image
    opening_image = @headers[:opening_image] || ""
  end
  
  def images
    imgs = @headers[:images] if @headers[:images] ||= []
  end

  def meta_keywords
    @headers[:meta_keywords] if @headers[:meta_keywords] ||= Site.meta_keywords
  end
  
  def meta_description
    @headers[:meta_description] if @headers[:meta_description] ||= "#{@headers[:title]} - #{Site.title}"
  end
  
  def has_images?
    images.size > 0
  end
  
  def time_ago (time)
    time.strftime("%Y-%m-%d")
  end
  
  def legacy_url
    legacy_url = @headers[:legacy_url] || ""
  end
  
  def legacy_url?
    legacy_url != ""
  end
  
  def self.archive
    years_months_posts = Post.find(:headers => {:published => true}).inject({}) do |archive, post|
      year_month = Time.local(post.published_at.year, post.published_at.month)
      archive[year_month] ||= []
      archive[year_month] << post
      archive
    end
    years_months_posts.sort.reverse
  end
  
  # Find posts that are tagged with a given tag
  def self.find_tagged_with (tag)
    posts = Post.find :headers => { :tags => tag }
    posts.sort
  end
  
  # Sort by publish date in reverse order
  def <=> (rhs)
    rhs.published_at <=> published_at
  end
  
end