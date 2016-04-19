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
    user = User.first(name: params["username"])
    parent = Parent.first(name: params["username"])
    if user && user.password == params["password"]
      session[:user_id] = user.id
    elsif parent && parent.password == params["password"]
      session[:user_id] = parent.id
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
    @options = ['Ja', 'Nej']
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
    notification = params[:notifications]
    Parent.create(name: name, email: email, password: password, notification: notification)
    redirect '/'
  end

  get '/overview' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @events = Event.all(user: @user)
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      @parentevents = Event.all(user: @parent)
    end
    erb :overview
  end

  get '/create_event' do
    erb :create_event
  end

  get '/create_schedule' do
    erb :create_schedule
  end

  post '/create_event' do
    @user = User.first(id: session[:user_id]).id
    name = params['name']
    date = params['date']
    time = params['time']
    description = params['description']
    Event.create(name: name, date: date, time: time, description: description, user_id: @user)

    #redirect '/overview'
  end

  post '/create_schedule' do
  end


end