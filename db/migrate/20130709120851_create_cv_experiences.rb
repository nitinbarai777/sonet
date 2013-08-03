class CreateCvExperiences < ActiveRecord::Migration
  def change
    create_table :cv_experiences do |t|
    	t.date :from
    	t.date :to
    	t.string :company_name
    	t.string :job_title
    	t.text :description
			t.references :user
			t.references :cv
      t.timestamps
    end
  end
end
