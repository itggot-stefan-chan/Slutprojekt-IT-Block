class Request
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, required: true
  property :parent_name, String, required: true, unique: true

  belongs_to :parent
end