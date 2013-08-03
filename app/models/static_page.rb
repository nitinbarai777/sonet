class StaticPage < ActiveRecord::Base
  
  validates :name, :presence => true
  validates :page_route, :presence => true
	scope :footer, -> {where(:is_footer => true)}  
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
end
