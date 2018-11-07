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
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts (id INTEGER PRIMARY KEY AUTOINCREMENT, created_date DATE, content TEXT);'
end

get '/' do
	erb "Hello!"		
end

get '/new' do
	erb :new
end

post '/new' do
	content = params[:content]

	erb "You typer #{content}"
  end