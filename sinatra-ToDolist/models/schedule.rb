class Schedule
  include DataMapper::Resource

  property :id, Serial
  property :creator, String, required: true, unique: true

  belongs_to :user
  has n, :lessons

end