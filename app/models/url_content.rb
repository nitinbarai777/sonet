class UrlContent < ActiveRecord::Base
  belongs_to :user_url
  
  validates :content, :presence => true
  
  def self.search(search)
    if search
      where('content LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
    
end
