configure do
  require 'ostruct'
  	Site = OpenStruct.new(
  	  :title => 'We the Creatives',
  	  :tag_line => 'creativity, technology, life and interviews with passionate and inspiring people',
  		:author => 'Kristian Laustsen',
  		:author_url => 'http://about.me/kristianlaustsen',
  		:meta_title => '',
  		:meta_description => 'creativity, technology, life and interviews with passionate and inspiring people',
  		:meta_keywords => 'creativity, technology, life and interviews with passionate and inspiring people',
  		:read_more_text => 'Read more'
  	)
end

configure :production do
  require 'newrelic_rpm'
end