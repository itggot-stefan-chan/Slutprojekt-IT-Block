class Seeder

  def self.seed!
    users
    events
  end

  def self.users
    User.create(name: 'Stefan Chan', email: 'stefan2846@hotmail.com', password: 123123, notification: 'Ja')
  end

  def self.events
    Event.create(name: 'Gymma', date: '04-19', time: '15:00', description: 'Dem Gainz', user_id: 1)
  end

end