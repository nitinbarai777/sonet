class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.references :category
      t.references :user
      t.string :subject
      t.text :content_text
      t.timestamps
    end
  end
end
