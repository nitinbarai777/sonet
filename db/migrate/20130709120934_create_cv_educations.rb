class CreateCvEducations < ActiveRecord::Migration
  def change
    create_table :cv_educations do |t|
    	t.string :school
    	t.string :from_year
    	t.string :to_year
    	t.string :degree
    	t.string :field_of_study
    	t.string :grade
    	t.string :activities
    	t.text :description
			t.references :user
			t.references :cv
      t.timestamps
    end
  end
end
