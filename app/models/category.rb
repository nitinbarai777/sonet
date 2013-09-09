class Category < ActiveRecord::Base
  validates :name, :presence => true
  has_many :contents, :dependent => :destroy
  scope :active, -> {where(:is_active => true)}  
end
