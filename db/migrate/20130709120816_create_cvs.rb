class CreateCvs < ActiveRecord::Migration
  def change
    create_table :cvs do |t|
    	t.text :summary
    	t.string :picture_filename
			t.references :user
      t.timestamps
    end
  end
end
