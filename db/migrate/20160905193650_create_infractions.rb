class CreateInfractions < ActiveRecord::Migration
  def change
    create_table :infractions do |t|
    	t.belongs_to :inspection, index: true
    	t.string :violation_summary
		t.string :category
		t.string :oneword_category
		t.string :code_subsection
		t.string :status
		t.string :short_description
		t.integer :multiplier
		t.string :extra_notes
		t.timestamps null: false
    end
  end
end
