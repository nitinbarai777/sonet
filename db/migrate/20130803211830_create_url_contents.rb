class CreateUrlContents < ActiveRecord::Migration
  def change
    create_table :url_contents do |t|
      t.text :content
      t.boolean :is_facebook_shared, :default => false
      t.boolean :is_twitter_shared, :default => false
      t.boolean :is_google_shared, :default => false
      t.references :user_url
      t.timestamps
    end
  end
end
