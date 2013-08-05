class AddFacebookPostIdToUrlContents < ActiveRecord::Migration
  def change
    add_column :url_contents, :facebook_post_id, :string, :after => :user_url_id
    add_column :url_contents, :facebook_likes_count, :integer, :default => 0, :after => :facebook_post_id
  end
end
