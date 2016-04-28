class Event
  include DataMapper::Resource

  property :id, Serial
  property :creator, String, required: true
  property :name, String, required: true
  property :date, String, required: true
  property :time, String, required: true
  property :description, String
  property :secret, String, required: true

  belongs_to :user
  belongs_to :parent

end