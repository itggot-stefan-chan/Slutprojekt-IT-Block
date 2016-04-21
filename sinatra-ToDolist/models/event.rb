class Event
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true
  property :date, String, required: true
  property :time, String, required: true
  property :description, String

  belongs_to :user
  belongs_to :parent

end