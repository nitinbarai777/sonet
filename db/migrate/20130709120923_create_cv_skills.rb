class CreateCvSkills < ActiveRecord::Migration
  def change
    create_table :cv_skills do |t|
    	t.string :name
    	t.string :sequence
			t.references :user
			t.references :cv
      t.timestamps
    end
  end
end
