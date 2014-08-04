class MyCar
  attr_accessor :color, :year, :make, :model, :color
  #attr_reader :year


  def initialize(year, make, model, color)
    @year = year
    @make = make
    @model = model
    @color = color
    @current_speed = 0
  end

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
    puts "Put it in park, and grab a snow cone!"
  end

  def self.calculate_gas_mileage(miles, gallons)
    puts "Your vehicle gets #{miles / gallons} mpg."
  end

  def to_s
    "My car is a #{year} #{color} #{make} #{model}."
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

