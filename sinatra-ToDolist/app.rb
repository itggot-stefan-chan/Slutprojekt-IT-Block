class App < Sinatra::Base
  enable :sessions

  get '/' do
    if session[:user_id]
      @user = User.get(session[:user_id])
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
    end
  	erb :index
  end

  post '/login' do
    user = User.first(name: params[:username])
    parent = Parent.first(name: params[:username])
    if user && user.password == params[:password]
      session[:user_id] = user.id
    elsif parent && parent.password == params[:password]
      session[:parent_id] = parent.id
    end
    redirect '/overview'
  end

  post '/logout' do
    session.destroy
    redirect '/'
  end

  get '/register' do
    @options = ['Ja', 'Nej']
    erb :register
  end

  get '/parent_register' do
    erb :parent_register
  end

  post '/create_user' do
    name = params[:name]
    email = params[:email]
    password = params[:password]
    notification = params[:notifications]
    User.create(name: name, email: email, password: password, notification: notification)
    redirect '/'
  end

  post '/create_parent' do
    name = params[:name]
    email = params[:email]
    password = params[:password]
    Parent.create(name: name, email: email, password: password)
    redirect '/'
  end

  get '/overview' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @events = Event.all(user: @user)
      erb :overview
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      @events = Event.all(parent: @parent, secret: 'Nej')
      erb :overview
    end
  end

  get '/create_event' do
    if session[:user_id]
      @options = ['Ja', 'Nej']
      @user = User.get(session[:user_id])
      erb :create_event
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      @relations = Relation.all(parent: @parent)
      erb :create_event
    end
  end

  get '/create_schedule' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      erb :create_schedule
    end
  end

  post '/create_event' do
    if session[:user_id]
      @parent_name = Relation.first(session[:parent_name])
      @user = User.first(id: session[:user_id]).id
      creator = User.first(session[:user_name]).name
      name = params[:name]
      date = params[:date]
      time = params[:time]
      description = params[:description]
      secret = params[:secret]
      Event.create(creator: creator, name: name, date: date, time: time, description: description, secret: secret, user_id: @user, parent_id: @parent_name.id)
      redirect '/overview'
    elsif session[:parent_id]
      @parent = Parent.first(id: session[:parent_id]).id
      user_id = params[:user]
      creator = Parent.first(session[:parent_name]).name
      name = params[:name]
      date = params[:date]
      time = params[:time]
      description = params[:description]
      secret = 'Nej'
      p Event.create(creator: creator, name: name, date: date, time: time, description: description, secret: secret, user_id: user_id, parent_id: @parent)
      redirect '/overview'
    end
  end

  post '/event/:id/delete' do |event_id|
    event = Event.get(event_id)
    if event
      event.destroy
      redirect back
    else
      status 404
    end
  end

  post '/create_schedule' do
  end

  get '/parents' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @parents = Relation.all(user: @user)
      erb :parents
    end
  end

  get '/add_user' do
    if session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      erb :add_user
    end
  end

  post '/adding_user' do

  end

  get '/calender' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      erb :calender
    end
  end

end