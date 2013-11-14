require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require 'will_paginate'
require 'will_paginate/active_record'

Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each { |f| load(f) }
Dir["#{File.dirname(__FILE__)}/models/*.rb"].each { |f| load(f) }
 
set :database, "sqlite3:///sftp-cowboy.db"

enable :sessions
register Sinatra::Flash

get '/' do
  @users = User.order(:username).page(params[:page]).per_page(25)
  erb :"users/index"
end

post '/users' do
  @user = User.new(params[:user])
  if @user.save
    flash[:success] = "User created successfully." 
  else
    flash[:failure] = @user.errors.full_messages
  end

  redirect "/"
end

get "/users/:id/edit" do
  @user = User.find(params[:id])
  erb :"users/edit"
end

put "/users/:id" do
  @user = User.find(params[:id])
  if @user.update_attributes(params[:user])
    @user.update_password!
    flash[:success] = "User updated successfully."
    redirect '/'
  else
    flash.now[:failure] = @user.errors.full_messages
    erb :"users/edit"
  end
end
 
# Deletes the post with this ID and redirects to homepage.
delete "/users/:id" do
  @user = User.find(params[:id]).destroy
  flash[:success] = "User deleted successfully."
  redirect "/"
end

get '/admins' do
  @admins = Admin.order(:username).page(params[:page]).per_page(25)
  erb :"admins/index"
end

post '/admins' do
  @admin = Admin.new(params[:admin])
  if @admin.save
    flash[:success] = "Admin created successfully." 
  else
    flash[:failure] = @admin.errors.full_messages
  end

  redirect "/admins"
end

get "/admins/:id/edit" do
  @admin = Admin.find(params[:id])
  erb :"admins/edit"
end

put "/admins/:id" do
  @admin = Admin.find(params[:id])
  if @admin.update_attributes(params[:admin])
    @admin.update_password!
    flash[:success] = "Admin updated successfully."
    redirect '/admins'
  else
    flash.now[:failure] = @admin.errors.full_messages
    erb :"admins/edit"
  end
end
 
# Deletes the post with this ID and redirects to homepage.
delete "/admins/:id" do
  @admin = Admin.find(params[:id]).destroy
  flash[:success] = "Admin deleted successfully."
  redirect "/admins"
end
