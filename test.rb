require 'rubygems'
require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :username => "root",
  :password => "",
  :database => "db",
  :socket => "/opt/lampp/var/mysql/mysql.sock"
)

DataMapper::setup(:default, "mysql:db")
DataMapper.finalize
DataMapper.auto_migrate!
DataMapper.auto_upgrade!

class Note < ActiveRecord::Base
	include DataMapper::Resource

	property :id, Serial
end


class App < Sinatra::Application
end

get '/' do
  @notes = Note.all
  @title = 'All Companies'  
  erb :notes
end

post '/' do
	n = Note.new
	n.name = params[:content]
	n.save
	redirect '/'
end

get '/:id' do
	@note = Note.get(params[:id])
  @title = "Edit Company ##{params[:id]}"  
  erb :edit
	
end