require 'csv'

require_relative 'restaurant'
require_relative 'menu'

module DataLoader

  #Reads latest restaurant and menu csv
  def self.load_restaurants_and_menu(rst_csv, menu_csv)
    load_restaurants rst_csv
    load_menus menu_csv
  end

  #Read csv and populate restaurants (assuming csv is in the specified format)
  def self.load_restaurants path
    csv_file_path = path.to_s
    CSV.foreach(csv_file_path, headers: true) do |row|
      rst = Restaurant.new(id: row[0], delivery_charge: row[1])
      Restaurant.populate rst
    end
  end

  #Read csv and populate menu items (assuming csv is in the specified format)
  def self.load_menus path
    csv_file_path = path.to_s
    CSV.foreach(csv_file_path, headers: true) do |row|
      restaurant = Restaurant.find(row[0])
      next if restaurant.nil? # skip menu items which do not have valid restaurant_id
      menu_item = MenuItem.new(item: row[2], price: row[1])
      restaurant.menu.add_item menu_item
    end
  end
end

