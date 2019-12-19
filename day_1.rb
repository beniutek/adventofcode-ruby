module Day1
  class << self
    def load_input
      IO.readlines('day_1_input').map { |line| line.chomp.to_i }
    end

    def part1
      input = load_input
      input.map { |mass| calc_fuel(mass) }.sum
    end

    def part2
      input = load_input
      input.map{ |mass| calc_full_fuel(mass) }.sum
    end

    def calc_fuel(input)
      (input/3.0).floor - 2
    end

    def calc_full_fuel(input)
      result = calc_fuel(input)
      result <= 0 ? 0 : (result + calc_full_fuel(result))
    end
  end
end
