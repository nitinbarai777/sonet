class CreatePages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
			t.string :name, :null => true
			t.string :page_route, :null => true
			t.text :content
			t.boolean :is_footer, :default => true
      t.timestamps
    end
  end
end
