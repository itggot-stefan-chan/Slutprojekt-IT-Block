class Event
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true
  property :date, Date, required: true
  property :time, Time, required: true
  property :description, String

  belongs_to :user

end