require 'csv'
class Restaurant

  attr_reader :id, :delivery_charge, :menu

  @@rst = {}

  def initialize(id:, delivery_charge:)
    @id = id.to_s
    @delivery_charge = delivery_charge.to_f
    @menu = Menu.new
  end

  # finds restaurant
  def self.find(id)
    @@rst[id.to_s]
  end

  # populates restaurant
  def self.populate(restaurant)
    @@rst[restaurant.id] = restaurant
  end

  # returns data
  def self.data
    @@rst
  end

  #finds restaurants that can fulfill this order
  def self.get_all_eligible_for item_list
    eligible_rst = []
    data.each { |id, restaurant| eligible_rst << restaurant if restaurant.menu.has_items?(item_list) }
    eligible_rst
  end

end
