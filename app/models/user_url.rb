class UserUrl < ActiveRecord::Base
  has_many :url_contents, :dependent => :destroy
  belongs_to :user
  validates :url_name, :presence => true
  validates :title, :presence => true
  validates :desc, :presence => true
  validates :image, :presence => true

  mount_uploader :image, ImageUploader
    
  def self.search(search)
    if search
      where('url_name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end  
  
end
