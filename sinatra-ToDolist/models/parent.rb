class Parent
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true, unique: true
  property :email, String, unique: true, required: true
  property :password, BCryptHash, required: true

  has n, :relations
  has n, :users, through: :relations
  has n, :events
end