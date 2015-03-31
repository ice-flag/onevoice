class AddLicensePlateDetailsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :lp_make, :string
    add_column :posts, :lp_model, :string
    add_column :posts, :lp_year, :string
    add_column :posts, :lp_cylinder, :string
    add_column :posts, :lp_car_category, :string
    add_column :posts, :lp_model_type, :string
    add_column :posts, :lp_seats, :string
    add_column :posts, :lp_fuel, :string
    add_column :posts, :lp_apk, :string
  end
end
