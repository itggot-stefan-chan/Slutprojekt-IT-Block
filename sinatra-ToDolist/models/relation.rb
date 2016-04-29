class Relation
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, required: true
  property :parent_name, String, required: true

  belongs_to :parent
  belongs_to :user

end