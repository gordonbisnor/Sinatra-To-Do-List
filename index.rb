require 'rubygems'
require 'sinatra'
require 'rubygems'
require 'activerecord'
require 'sinatra' unless defined?(Sinatra)
require 'models/list'
require 'models/list_item'

configure do
  APP_CONFIG = OpenStruct.new(YAML.load_file("config/config.yml"))
end

# HTTP AUTHORIZATION
use Rack::Auth::Basic do |username, password|
  [username, password] == [APP_CONFIG.user, APP_CONFIG.password]
end

enable :methodoverride 

# DATABASE
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3',:dbfile => APP_CONFIG.db)

 # HOME PAGE (SHOW LATEST LIST)
get '/' do           
  @list = List.last
  @lists = List.all(:order => 'completed ASC,position ASC')
  erb :'lists/show' 
end

# LIST INDEX 
get '/lists' do
  @lists = List.all(:order => 'completed ASC,position ASC')
  erb :'lists/index'
end

# NEW LIST 
get '/lists/new' do 
  @lists = List.all(:order => 'completed ASC,position ASC')
  erb :'lists/new'
end

# LIST SHOW
get '/lists/:id' do
  @lists = List.all(:order => 'completed ASC,position ASC')
  @list = List.find(params[:id])
  erb :'lists/show'
end

# CREATE LIST
post '/lists' do 
  @list = List.new(params[:list]).save
  redirect '/'
end

# DELETE LIST
delete '/lists' do
  @list = List.find(params[:id]).destroy
  redirect '/'
end

# NEW ITEM
post '/items' do
  @item = ListItem.new(params[:item])
  @lists = List.all(:order => 'completed ASC,position ASC')
  @item.save
  redirect '/'
end

# SORT LIST
post '/items/sort' do
  params[:list_items].each_with_index do |id, pos|
    ListItem.find(id).update_attribute(:position, pos+1)
  end 
end
               
# EDIT ITEM
put '/items' do
  @list = ListItem.find(params[:id])
  @list.update_attributes(params[:list])
  @list.save
  redirect '/'
end  

# DELETE ITEM
delete '/items' do
  @item = ListItem.find(params[:id]).destroy
  redirect '/'
end

# VIEW HELPERS
helpers do
  def completed? item
    item.completed ? "complete" : "incomplete"
  end
end