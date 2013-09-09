class User < ActiveRecord::Base

	include ActionView::Helpers::TextHelper
	
  acts_as_authentic do |c|
    c.validate_email_field = false
    c.login_field = 'username'
  end

  mount_uploader :image, ImageUploader
  
  attr_writer :password_required

  validates_presence_of :password, :if => :password_required?

  def password_required?
    @password_required
  end    
  
	validates_uniqueness_of :username
	validates :email, :presence => true
	
	has_one :user_role, :dependent => :destroy
	has_one :role, :through => :user_role
	has_one :authorization, :dependent => :destroy
	has_many :user_urls, :dependent => :destroy
	
	has_many :contents, :dependent => :destroy
	
  def self.search(search)
    if search
      where('(users.username LIKE ? OR users.email LIKE ? OR users.contact LIKE ?)', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
  
	def user_name
		return self.username.gsub(" ", "_")
	end
	
  def has_role?(role)
    self.user_role.role.role_type == role
  end
  
  def is_super_admin?
    has_role?("SuperAdmin")
  end
  
  def is_user?
    has_role?("User")
  end
  
  def is_provider_user?
    self.authorization
  end  
  
  def is_facebook_user?
    self.authorization.provider == 'facebook'
  end
  
  def is_twitter_user?
    self.authorization.provider == 'twitter'
  end    
  
  def is_google_user?
    self.authorization.provider == 'google_oauth2'
  end            
  
 
  def name(shorten=true)
    unless first_name.nil? && last_name.nil? or first_name.empty? && last_name.empty?
      [first_name, last_name].join(" ")
    else
      shorten ? truncate(email, :omission => "..", :length => 20) : email
    end
  end  

  def user_name(shorten=true)
    unless first_name.nil? && last_name.nil? or first_name.empty? && last_name.empty?
      [first_name, last_name].join("-")
    else
      shorten ? truncate(email, :omission => "..", :length => 20) : email
    end
  end 
  	
end
