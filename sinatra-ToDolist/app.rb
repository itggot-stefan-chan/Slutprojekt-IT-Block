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
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      @events = Event.all(parent: @parent, secret: 'Nej')
    end
    erb :overview
  end

  get '/create_event' do
    @options = ['Ja', 'Nej']
    @user = User.get(session[:user_id])
    erb :create_event
  end

  get '/create_schedule' do
    erb :create_schedule
  end

  post '/create_event' do
    @parent_name = Relation.first(session[:parent_name])
    @user_name = Relation.first(session[:user_name])
    if session[:user_id]
      @user = User.first(id: session[:user_id]).id
      creator = User.first(id: session[:user_id]).name
      name = params[:name]
      date = params[:date]
      time = params[:time]
      description = params[:description]
      secret = params[:secret]
      Event.create(creator: creator, name: name, date: date, time: time, description: description, secret: secret, user_id: @user, parent_id: @parent_name.id)
      redirect '/overview'
    elsif session[:parent_id]
      @parent = Parent.first(id: session[:parent_id]).id
      creator = Parent.first(session[:parent_name])
      name = params[:name]
      date = params[:date]
      time = params[:time]
      description = params[:description]
      secret = 'Nej'
      Event.create(creator: creator, name: name, date: date, time: time, description: description, secret: secret, user_id: @user_name.id, parent_id: @parent)
      redirect '/overview'
    end
  end

  post '/create_schedule' do
  end

  get '/parents' do
    erb :parents
  end

  get '/add_user' do
    erb :add_user
  end

  get '/calender' do
    erb :calender
  end

end