class Seeder

  def self.seed!
    users
    parents
    events
    relations
    schedules
    lessons
  end

  def self.users
    User.create(name: 'Stefan Chan', email: 'stefan2846@hotmail.com', password: 123123, notification: 'Ja')
    User.create(name: 'Zygor', email: 'stefan.chan@hotmail.com', password: 123123, notification: 'Nej')
    User.create(name: 'daero', email: 'aq.shadow@live.com', password: 123123, notification: 'Ja')
  end

  def self.parents
    Parent.create(name: 'Illnoid', email: 'elvarg.shadow@hotmail.com', password: 123456)
  end

  def self.events
    Event.create(creator: 'Illnoid', name: 'Gymma', date: '2016-04-19', time: '15:00', description: 'Dem Gainz', secret: 'Nej', user_id: 1, parent_id: 1)
    Event.create(creator: 'Illnoid', name: 'Do the dishes', date: '2016-05-28', time: '19:00', description: 'Do it now', secret: 'Nej', user_id: 2, parent_id: 1)
    Event.create(creator: 'Illnoid', name: 'Do the dishes2', date: '2016-05-28', time: '19:00', description: 'Do it now', secret: 'Nej', user_id: 2, parent_id: 1)
    Event.create(creator: 'Illnoid', name: 'Do the dishes3', date: '2016-05-28', time: '19:00', description: 'Do it now', secret: 'Nej', user_id: 2, parent_id: 1)
    Event.create(creator: 'Illnoid', name: 'Do the dishes4', date: '2016-05-28', time: '19:00', description: 'Do it now', secret: 'Nej', user_id: 2, parent_id: 1)
    Event.create(creator: 'Illnoid', name: 'Do the dishes5', date: '2016-05-28', time: '19:00', description: 'Do it now', secret: 'Nej', user_id: 2, parent_id: 1)
  end

  def self.relations
    Relation.create(user_name: 'Stefan Chan', user_id: 1, parent_name: 'Illnoid', parent_id: 1)
    Relation.create(user_name: 'Zygor', user_id: 2, parent_name: 'Illnoid', parent_id: 1)
  end

  def self.schedules
    Schedule.create(creator: 'Stefan Chan',user_id: 1)
    Schedule.create(creator: 'Zygor',user_id: 2)
  end

  def self.lessons
    Lesson.create(name: 'English', day: 'Monday', time: '17:00', creator: 'Stefan Chan', schedule_id: 1)
    Lesson.create(name: 'Mathematics', day: 'Wednesday', time: '13:00', creator: 'Zygor', schedule_id: 2)
  end

end