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
	
end

get '/' do
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

	erb "You typed: #{content}"
  end