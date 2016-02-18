def cleanup(data)
	def filter(datum)
		return String(datum).gsub(/[^\w\s\-\/]/, "").gsub(/\r?\n|\r|\t/,"").gsub(/\s+/, " ").gsub(/<[^>]*>/, "")
	end
	data.each do |key, value|
		if value.class == Hash
			data[key] = cleanup(value)
		elsif value.class == Array
			value.each do |val|
				cleanup(val)
			end
		else
			if !["latitude", "longitude", "Program Profile"].include?(key)
				data[key] = filter(value)
			end
		end
	end
end