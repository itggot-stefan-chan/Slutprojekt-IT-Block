class Seeder

  def self.seed!
    users
    parents
    events
    relations
  end

  def self.users
    User.create(name: 'Stefan Chan', email: 'stefan2846@hotmail.com', password: 123123, notification: 'Ja')
  end

  def self.parents
    Parent.create(name: 'Illnoid', email: 'elvarg.shadow@hotmail.com', password: 123456)
  end

  def self.events
    Event.create(creator: 'Illnoid', name: 'Gymma', date: '04-19', time: '15:00', description: 'Dem Gainz', secret: 'Nej', user_id: 1, parent_id: 1)
  end

  def self.relations
    Relation.create(user_name: 'Stefan Chan', user_id: 1, parent_name: 'Illnoid', parent_id: 1)
  end

end