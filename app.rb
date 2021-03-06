#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'jifeblog.db'
	@db.results_as_hash = true
end

# calls "before" every time when page reload
before do

	init_db
end

configure do
	# Initialization bd
	init_db
	# Create bd if table not exists
	@db.execute 'CREATE TABLE IF NOT EXISTS "Posts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "created_date" DATE, "content" TEXT);'
	@db.execute 'CREATE TABLE IF NOT EXISTS "Comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "created_date" DATE, "content" TEXT, "post_id" INTEGER);'

end

get '/' do
	# select a list of posts from the database
	@results = @db.execute 'select * from Posts order by id desc'

	erb :index	
end

get '/new' do
	erb :new
end

post '/new' do
	content = params[:content]

	# Add parametr validation
	if content.size < 1
		@error = "Type post text!"
		return erb :new
	end

	# Safe data to db
	@db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

	redirect to '/'
end

# Show information about post
get '/details/:post_id' do
  # get variable from url
  post_id = params[:post_id]

  # get a list of posts
  results = @db.execute 'select * from Posts where id = ?', [post_id]
  # choose this one post in variable @row
  @row = results[0]

  # Choice comment for post
  @comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]
	
  # return view details.erb
  erb :details
end

post '/details/:post_id' do
	post_id = params[:post_id]

	content = params[:content]

	@db.execute 'insert into Comments (content, created_date, post_id) values (?, datetime(), ?)', [content, post_id]

	redirect to('/details/' + post_id)

end
