class CreateCvLanguages < ActiveRecord::Migration
  def change
    create_table :cv_languages do |t|
    	t.string :language
    	t.string :proficiency
			t.references :user
			t.references :cv
      t.timestamps
    end
  end
end
