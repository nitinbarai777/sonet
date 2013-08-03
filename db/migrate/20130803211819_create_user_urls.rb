class CreateUserUrls < ActiveRecord::Migration
  def change
    create_table :user_urls do |t|
      t.string :url_name
      t.string :title
      t.string :image
      t.text :desc
      t.references :user
      t.timestamps
    end
  end
end
