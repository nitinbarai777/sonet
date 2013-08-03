class User < ActiveRecord::Base
	
	include LinkedinHandler
	include ActionView::Helpers::TextHelper
	
  acts_as_authentic do |c|
    c.validate_email_field = false
    c.login_field = 'username'
  end
  
  attr_writer :password_required

  validates_presence_of :password, :if => :password_required?

  def password_required?
    @password_required
  end    
  
	validates_uniqueness_of :username
	validates :email, :presence => true
	has_one :user_role, :dependent => :destroy
	has_one :role, :through => :user_role
	has_many :authorizations, :dependent => :destroy
	
	has_one :cv, :dependent => :destroy
	has_many :cv_educations
	has_many :cv_experiences
	has_many :cv_languages
	has_many :cv_skills

	has_many :invitings, :class_name => "Invite", :foreign_key => "inviting_user_id", :dependent => :destroy
	has_many :inviteds, :class_name => "Invite", :foreign_key => "invited_user_id", :dependent => :destroy
	
	has_many :invitings_read_logs, :class_name => "ReadLog", :foreign_key => "inviting_user_id", :dependent => :destroy
	has_many :inviteds_read_logs, :class_name => "ReadLog", :foreign_key => "invited_user_id", :dependent => :destroy	
	
  def self.search(search)
    if search
      where('(users.username LIKE ? OR users.email LIKE ? OR users.contact LIKE ?)', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
  
	def user_name
		return self.first_name.blank? ? self.username : (self.first_name.to_s + " " + self.last_name.to_s)
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
    self.authorizations
  end  
  
  def has_cv?
  	self.cv	
  end
  
  def is_not_invited_user(invited_user_id)
  	self.id != invited_user_id
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
