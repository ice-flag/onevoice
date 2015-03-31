class Post < ActiveRecord::Base
  attr_accessible :name, :category,
  								# to make API call to find out license plate vehicle details
  								:license_plate, #string
  								# car details API call result (string fields)
  								:lp_car_category, 
  								:lp_make, :lp_model, :lp_year, :lp_cylinder,
  								:lp_model_type, :lp_seats, :lp_fuel, :lp_apk,
  								# for account creation
  								:email, #string
  								# posting values
  								:description, #text
  								:supplier_parts #integer
end