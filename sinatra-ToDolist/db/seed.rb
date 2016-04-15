class Seeder

  def self.seed!
    users
  end

  def self.users
    User.create(name: 'Stefan Chan', email: 'stefan2846@hotmail.com', password: 123123, notification: 'Ja')
  end

end