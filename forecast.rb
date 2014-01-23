require 'awesome_print'
require 'forecast_io'
require_relative 'get_lat_long.rb'


ENV.update YAML.load(File.read(File.expand_path('../forecast.yml',__FILE__)))


class Weatherapp

	def initialize(lat,long)
		ForecastIO.api_key = ENV["forecast_api"]
		@forecast = ForecastIO.forecast(lat,long) 
	end 


	###### weather forecast ######

	def right_now 
		icon = @forecast.currently.icon
		#puts icon
		puts "The weather now is: #{@forecast.currently.summary} with a temperature of #{@forecast.currently.temperature} fahrenheit"
	end



	def today 
		icon = @forecast.hourly.icon
		#puts icon
		puts "The forecast for today is #{@forecast.hourly.summary} The average temperature for today is #{@forecast.currently.temperature} fahrenheit"
		if icon == "rain" || icon == "snow"
			puts "You're going to need an umbrella for the #{icon} today"
		end 
	end 

	

	def week 
		icon = @forecast.daily.icon
		#puts icon 
		puts "The weather this week is going to be #{@forecast.daily.summary}"
	end 
end 



p "Hello, what is your zipcode?"
zipcode = STDIN.gets.chomp()
location = Geolatlong.new(zipcode)
location.get_coordinates
location.your_local
lat = location.lat
long = location.long
weather = Weatherapp.new(lat,long)
p "Would you like to know the weather for right now, today, or the week?"
p "Type 'now' for the weather right now."
p "Type 'today' for the weather today."
p "Type 'week' the weather this week."
show_weather = STDIN.gets.downcase.chomp()
case show_weather
	when "now"
		puts weather.right_now
	when "today"
		puts weather.today
	when "week"
		puts weather.week
	else
		puts "this request isn't valid."
end 











