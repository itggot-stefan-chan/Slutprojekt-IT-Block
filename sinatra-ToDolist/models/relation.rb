class Relation
  include DataMapper::Resource

  property :id, Serial

  belongs_to :parent
  belongs_to :user

end