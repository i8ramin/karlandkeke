class CreateInspection < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
    	t.belongs_to :daycare, index: true
    	t.string :result
    	t.date :date
    end
    # add_reference :inspections, :daycares, index: true
  	# add_foreign_key :inspections, :daycares
  end
end
