class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true
  property :email, String, required: true, unique: true
  property :password, BCryptHash, required: true
  property :notification, String, required: true

  has n, :relations
  has n, :parents, through: :relations
  has n, :events

end