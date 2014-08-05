class MyVehicle
  attr_accessor :number_of_vehicles

  @@number_of_vehicles = 0

  def accelerate(number)
    @current_speed += number
    puts "You push the gas and accelerate #{number} mph."
  end

  def brake(number)
    @current_speed -= number
    puts "You push the brake and decelerate #{number} mph."
  end

  def current_speed
    puts "You're current speed is #{@current_speed} mph."
  end

  def shut_down
    @current_speed = 0
    puts "Park it, and turn it off."
  end

  def to_s
    "My #{type} is a #{year} #{color} #{make} #{model}."
  end

  def self.calculate_gas_mileage(miles, gallons)
    puts "Your vehicle gets #{miles / gallons} mpg."
  end

  def self.total_number_of_vehicles
    @@number_of_vehicles = MyCar.number_of_cars + MyTruck.number_of_trucks
    "There are #{number_of_vehicles} vehicles."
  end

end

class MyCar < MyVehicle
  attr_accessor :color, :year, :make, :model, :color, :type, :number_of_cars
  #attr_reader :year
  VEHICLE_TYPE = "car"
  @@number_of_cars = 0

  def initialize(year, make, model, color)
    @year = year
    @make = make
    @model = model
    @color = color
    @type = VEHICLE_TYPE
    @@number_of_cars += 1
    @current_speed = 0
  end

end

class MyTruck < MyVehicle
  attr_accessor :color, :year, :make, :model, :color, :type, :number_of_trucks
  #attr_reader :year
  VEHICLE_TYPE = "truck"
  @@number_of_trucks = 0


  def initialize(year, make, model, color)
    @year = year
    @make = make
    @model = model
    @color = color
    @type = VEHICLE_TYPE
    @@number_of_trucks += 1
    @current_speed = 0
  end

end

lesabre = MyCar.new(1989, 'buick', 'lesabre', 'white')
lesabre.accelerate(20)
lesabre.current_speed
lesabre.accelerate(20)
lesabre.current_speed
lesabre.brake(20)
lesabre.current_speed
lesabre.brake(20)
lesabre.current_speed
lesabre.shut_down
lesabre.current_speed
lesabre.color = 'black'
puts lesabre.color
puts lesabre.year
MyCar.calculate_gas_mileage(280,17)
puts lesabre


sierra = MyTruck.new(2000, 'GMC', 'sierra', 'white')
sierra.accelerate(20)
sierra.current_speed
sierra.accelerate(20)
sierra.current_speed
sierra.brake(20)
sierra.current_speed
sierra.brake(20)
sierra.current_speed
sierra.shut_down
sierra.current_speed
sierra.color = 'black'
puts sierra.color
puts sierra.year
MyTruck.calculate_gas_mileage(280,19)
puts sierra

#MyCar.total_number_of_vehicles
#MyTruck.total_number_of_vehicles
MyVehicle.total_number_of_vehicles

