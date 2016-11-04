class Product
  include Mongoid::Document
  include Mongoid::Paperclip
  has_mongoid_attached_file :image
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  
  belongs_to :store
  validates :name,        presence: true
  validates :description, presence: true
  validates :price,       presence: true

  field :name,         type: String
  field :description,  type: String
  field :price,        type: Float
  field :image_url,    type: String

end