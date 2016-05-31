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
      sort_event = []
      for event in @events
        sort_event << {:date => event.date, :id => event.id}
      end
      sort_event.sort_by! do |item|
        item[:date]
      end
      @sorted_event = []
      for item in sort_event do
        @sorted_event << Event.get(item[:id])
      end
      @schedule = Schedule.get(session[:user_id])
      @week = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
      @lessons = Lesson.all(schedule: @schedule)
      sort_lesson = []
      for lesson in @lessons
        sort_lesson << {:time => lesson.time, :id => lesson.id}
      end
      sort_lesson.sort_by! do |item|
        item[:time]
      end
      @sorted_lesson = []
      for item in sort_lesson do
        @sorted_lesson << Lesson.get(item[:id])
      end
      erb :overview
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      events = Event.all(parent: @parent, secret: 'Nej')
      sort_event = []
      for event in events
        sort_event << {:date => event.date, :id => event.id}
      end
      sort_event.sort_by! do |item|
        item[:date]
      end
      @sorted_event = []
      for item in sort_event do
        @sorted_event << Event.get(item[:id])
      end
      @users = Relation.all(parent: @parent)
      user_schedule = Schedule.all(user: @users.user)
      @week = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
      @lessons = Lesson.all(schedule: user_schedule)
      sort_lesson = []
      for lesson in @lessons
        sort_lesson << {:time => lesson.time, :id => lesson.id}
      end
      sort_lesson.sort_by! do |item|
        item[:time]
      end
      @sorted_lesson = []
      for item in sort_lesson do
        @sorted_lesson << Lesson.get(item[:id])
      end
      erb :overview
    else
      redirect '/'
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
    else
      redirect '/'
    end
  end


  get '/create_schedule' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @schedule = Schedule.get(session[:user_id])
      @week = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
      erb :create_schedule
    else
      redirect '/'
    end
  end

  post '/create_event' do
    if session[:user_id] && Relation.first(user_id: session[:user_id]) != nil
      @parent_id = Relation.first(user_id: session[:user_id]).parent_id
      @user = User.get(session[:user_id]).id
      creator = User.get(session[:user_id]).name
      name = params[:name]
      date = Date.parse(params[:date])
      time = params[:time]
      description = params[:description]
      secret = params[:secret]
      Event.create(creator: creator, name: name, date: date, time: time, description: description, secret: secret, user_id: @user, parent_id: @parent_id)
      redirect '/overview'
    elsif session[:user_id] && Relation.first(user_id: session[:user_id]) == nil
      user = User.get(session[:user_id]).id
      creator = User.get(session[:user_id]).name
      name = params[:name]
      date = Date.parse(params[:date])
      time = params[:time]
      description = params[:description]
      secret = params[:secret]
      Event.create(creator: creator, name: name, date: date, time: time, description: description, secret: secret, user_id: user)
      redirect '/overview'
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id]).id
      user_id = params[:user]
      creator = Parent.get(session[:parent_id]).name
      name = params[:name]
      date = Date.parse(params[:date])
      time = params[:time]
      description = params[:description]
      secret = 'Nej'
      Event.create(creator: creator, name: name, date: date, time: time, description: description, secret: secret, user_id: user_id, parent_id: @parent)
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

  post '/lesson/:id/delete' do |lesson_id|
    lesson = Lesson.get(lesson_id)
    if lesson
      lesson.destroy
      redirect back
    else
      status 404
    end
  end

  post '/relation/:id/delete' do |relation_id|
    relation = Relation.get(relation_id)
    if relation
      relation.destroy
      redirect '/overview'
    else
      status 404
    end
  end

  post '/create_lesson' do
    @user = session[:user_id]
    schedule = Schedule.get(session[:user_id])
    @schedule_id = schedule.id
    name = params[:name]
    day = params[:day]
    time = params[:time]
    creator = User.get(session[:user_id]).name
    Lesson.create(name: name, day: day, time: time, creator: creator, schedule_id: @schedule_id)
    redirect '/overview'
  end

  post '/create_schedule' do
    user = session[:user_id]
    creator = User.get(session[:user_id]).name
    Schedule.create(creator: creator, user_id: user)
    redirect '/overview'
  end

  get '/parents' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @relations = Relation.all(user: @user)
      @requests = Request.all(user_name: @user.name)
      erb :parents
    else
      redirect '/'
    end
  end

  post '/adding_parent' do
    user = User.get(session[:user_id]).name
    parent_name = Request.first(user_name: user).parent_name
    parent_id = Request.first(user_name: user).parent_id
    Relation.create(user_name: user, user_id: session[:user_id], parent_name: parent_name, parent_id: parent_id)
    Request.first(user_name: user).destroy
    redirect '/overview'
  end

  get '/add_user' do
    if session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      erb :add_user
    else
      redirect '/'
    end
  end

  post '/adding_user' do
    parent_id = session[:parent_id]
    user_name = params[:name]
    parent_name = Parent.get(session[:parent_id]).name
    p parent_name
    Request.create(user_name: user_name, parent_name: parent_name, parent_id: parent_id)
    redirect '/overview'
  end

  get '/calender' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @date = Date.new(Date.today.year,Date.today.month,1)
      @days = [1,2,3,4,5,6]
      @events = Event.all(user: @user)
      @event_dates = []
      for event in @events
        @event_dates << event.date.to_s
      end
      @event_dates = @event_dates.uniq
      erb :calender
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      @date = Date.new(Date.today.year,Date.today.month,1)
      @days = [1,2,3,4,5,6]
      @events = Event.all(parent: @parent, secret: 'Nej')
      @event_dates = []
      for event in @events
        @event_dates << event.date.to_s
      end
      @event_dates = @event_dates.uniq
      erb :calender
    else
      redirect '/'
    end
  end

end