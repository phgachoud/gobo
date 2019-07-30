note

	description:

		"Represents a location determining a time_zone"

	library: "Gobo Eiffel Time Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"

class DT_LOCATION

creation
	make,
	make_from_degrees

feature {NONE} -- Initialization

	make_from_degrees, make (a_longitude, a_latitude: like longitude)
		do
			longitude := a_longitude
			latitude := a_latitude
		ensure
			longitude = a_longitude
			latitude = a_latitude
		end

feature -- Access

	longitude, latitude: REAL
			-- Time zone

feature -- Status setting

	set_longitude (a_longitude: like longitude)
		do
			longitude := a_longitude
		ensure
			longitude = a_longitude
		end

	set_latitude (a_latitude: like latitude)
		do
			latitude := a_latitude
		ensure
			latitude = a_latitude
		end

feature -- Validation

	valid_longitude (a_longitude: like longitude): BOOLEAN
		do
			Result := a_longitude >= -180 and a_longitude <= 180
		end

	valid_latitude (a_latitude: like latitude): BOOLEAN
		do
			Result := a_latitude >= -90 and a_latitude <= 90
		end

feature -- Locations

	santiago_de_chile: like Current
		once
			create Result.make (-70.673676, -33.447487)
		ensure
			instance_free: Class
		end

invariant
	valid_longitude (longitude)
	valid_latitude (latitude)
end
