require_relative 'restaurant'
require_relative 'menu'
require_relative 'data_loader'

class Order
  #Finds best restaurant and in case of no such restaurant returns [-1,-1]
  def self.find_best_restaurant item_list
    eligible_rsts = Restaurant.get_all_eligible_for item_list
    min_cost = Float::INFINITY
    best_rst_id = nil
    unless eligible_rsts.empty?
      eligible_rsts.each do |rst|
        dc = rst.delivery_charge

        best_price = rst.menu.best_price_for_items(item_list)
        next unless best_price # should not consider if could not find best_price

        cost = best_price + dc
        min_cost, best_rst_id = [cost, rst.id] if min_cost > cost
      end
    end
    rst_id, cost = [best_rst_id, min_cost]
    rst_id.nil? ? [-1, -1] : ([rst_id, cost])
  end

  def self.execute
    puts "Enter path for restaurant csv (default: 'restaurants.csv')"
    rst_csv = gets.chomp.strip
    rst_csv = 'restaurants.csv' if rst_csv.empty?

    puts "Enter path for menu csv(default: 'menu.csv')"
    menu_csv = gets.chomp.strip
    menu_csv = 'menu.csv' if menu_csv.empty?

    DataLoader.load_restaurants_and_menu(rst_csv, menu_csv)

    puts 'Enter Items to be Ordered (comma separated)'
    item_list = gets.chomp.split(',').map(&:strip).uniq

    abort 'Please enter atleast 1 item. Aborting!' if item_list.empty?

    puts 'Best Price and Restaurant Combo is'
    st = Time.now
    puts Order.find_best_restaurant item_list
    et = Time.now
    puts (et -st) * 1000
    st = Time.now
    puts Store.find_best_price item_list
    et = Time.now
    puts (et - st) * 1000
  end

end

Order.execute

# DataLoader.load_restaurants_and_menu('restaurants.csv', 'menu.csv')
# p Order.find_best_restaurant ["steak_salad_sandwich","wine_spritzer"]
# p Order.find_best_restaurant ["steak_salad_sandwich"]
# p Order.find_best_restaurant ["fancy_european_water","extreme_fajita","jalapeno_poppers"]
# p Order.find_best_restaurant ["jalapeno_poppers"]
# p Order.find_best_restaurant ["extreme_fajita","fancy_european_water"]
# p Order.find_best_restaurant ["burger", "tofu_log"]
# p Order.find_best_restaurant ["tofu_log"]
# p Order.find_best_restaurant ["tofu_log","fancy_european_water"]
# p Order.find_best_restaurant ["extreme_fajita"]
# p Order.find_best_restaurant ["jam_toast"]

