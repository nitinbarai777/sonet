class Role < ActiveRecord::Base

	SUPER_ADMIN = "SuperAdmin"
	EDUCATOR = "Educator"
	AGENT = "Agent"
	EXPERT = "Expert"
	
  belongs_to :subscription
  has_many   :users     
  
  validates_presence_of :role_type
  validates_uniqueness_of :role_type
  def self.search(search)
    search ? (where('role_type LIKE ?', "%#{search}%")) : scoped
  end

end