class CreateDaycares < ActiveRecord::Migration
  def change
    create_table :daycares do |t|
      t.string :source
      t.string :daycare_type
      t.string :center_name
      t.string :permalink

      t.decimal :latitude
      t.decimal :longitude
      t.string :address
      t.string :borough
      t.string :zipcode
      t.string :phone
      t.string :permit_status
      t.string :permit_number
      t.string :permit_expiration_date
      t.string :age_range

      t.integer :maximum_capacity
      t.string :site_type
      t.boolean :certified_to_administer_medication
      t.integer :years_operating
      t.boolean :has_inspections
      t.string :grade

      t.timestamps null: false
    end
  end
end
