class Lesson
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true
  property :day, String, required: true
  property :time, String, required: true
  property :creator, String

  belongs_to :schedule

end