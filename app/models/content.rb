class Content < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  validates :subject, :presence => true
  validates :content_text, :presence => true
end
