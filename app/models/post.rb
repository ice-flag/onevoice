class Post < ActiveRecord::Base
  attr_accessible :name, :category,
  								# to make API call to find out license plate vehicle details
  								:license_plate, #string
  								# for account creation
  								:email #string
end