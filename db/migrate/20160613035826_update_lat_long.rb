class UpdateLatLong < ActiveRecord::Migration
  def change
	enable_extension "postgis"
  	change_table :daycares do |t|
		t.remove :latitude, :longitude
		t.st_point :lonlat, geographic: true
		t.index :lonlat, using: :gist
	end
  end
end
