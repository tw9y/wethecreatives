# 301 redirects - this should be moved to it's own file some day

get '/2010/10' do
  redirect '/archive', 301
end

get '/2010/11' do
  redirect '/archive', 301
end

get '/category/minimalism' do
  redirect '/archive', 301
end

get '/category/programming' do
  redirect '/archive', 301
end

get '/category/offices/' do
  redirect '/tags/companies', 301
end

get '/category/offices' do
  redirect '/tags/companies', 301
end

get '/category/talks' do
  redirect '/archive', 301
end

get '/offices/the-perfect-office' do
  redirect '/archive', 301
end

get '/articles/twitter-and-creativity' do
  redirect '/', 301
end

get '/talks/:slug' do
  redirect "/#{params[:slug]}", 301
end

get '/companies/:slug' do
  redirect "/#{params[:slug]}", 301
end

get '/info/:slug' do
  redirect "/#{params[:slug]}", 301
end

# end redirects