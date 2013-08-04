class UrlContent < ActiveRecord::Base
  belongs_to :user_url
  
  validates :content, :presence => true
  
  def self.search(search, provider)
    if search
      where('content LIKE AND ?', "%#{search}%")
    else
      scoped
    end
  end
    
end
