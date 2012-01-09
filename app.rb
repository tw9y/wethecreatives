require 'rubygems'
require 'sinatra'
require 'erb'
require 'moredown'
require 'lib/maneki'
require 'lib/models'
require 'lib/redirects'
require 'lib/configuration'
require 'lib/helpers'

get '/' do
  if params[:page] == '1'
     redirect '/'
   end
   @page = (params[:page] || 1).to_i
   @posts = Post.page(@page)|| raise(Sinatra::NotFound)
   erb :index
end

get '/about/?' do
  erb :about
end

get '/archive/?' do
  @posts_by_month_and_year = Post.archive
  erb :archive
end

get '/run-by-you/?' do
  erb :run_by_you
end

get '/great-books/?' do
  erb :great_books
end

get '/contact/?' do
  erb :contact
end

get '/feed' do
  @posts = Post.all
  content_type 'application/rss+xml'
  erb :feed, :layout => false
end

get '/sitemap.xml' do
  @posts = Post.all
  content_type 'text/xml'
  erb :sitemap, :layout => false
end

get '/tags/:tag/?' do
  @tag = params[:tag].downcase
  @posts = Post.find_tagged_with(@tag)
  erb :tag
end

get '/*' do
  @post = Post.find(params[:splat].join) || raise(Sinatra::NotFound)
  erb :post
end

not_found do
    erb :not_found
end