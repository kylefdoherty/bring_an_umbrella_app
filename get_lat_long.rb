require 'rest-client'
require 'crack/xml'

class Geolatlong
	attr_reader :location, :lat, :long, :sublocal, :city, :state
	#method for passsing in an address that can be added to the 
	#google maps url to return the lattitude, longitude, and other 
	#locations specific info
	def initialize(address)
		@base_google_maps_url = "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address="
		@location = address
		@lat = ""
		@long = ""
		@sublocal = ""
		@state = ""
		@city = ""
	end 

	#combines the goolge maps base url with the given 
	#location and returns location info 
	def get_coordinates
		coordinates = RestClient.get(URI.encode("#{@base_google_maps_url}#{@location}"))
		parsed_coordinates = Crack::XML.parse(coordinates)
		@lat = parsed_coordinates["GeocodeResponse"]["result"]["geometry"]["location"]["lat"]
		@long = parsed_coordinates["GeocodeResponse"]["result"]["geometry"]["location"]["lng"]
		@address_component = parsed_coordinates["GeocodeResponse"]["result"]["address_component"]
		
		if @address_component[1]["type"][0] == "sublocality"
		  @sublocal = @address_component[1]["long_name"]
		  @city = @address_component[2]["long_name"]
		  @state = @address_component[4]["short_name"]
		end

		if @address_component[1]["type"][0] == "locality"
	      @city = @address_component[1]["long_name"]
		  @state = @address_component[3]["long_name"]
		end 
	end

	def your_local
	  puts "Your location is: #{@sublocal} #{@city}, #{@state}"
	end  
end 
