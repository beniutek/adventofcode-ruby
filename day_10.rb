module Day10
  class << self
    def load_input
      IO.readlines('day10_input').map do |line|
        line.chomp.split('')
      end
    end

    def part1
      data = load_input

      max_observable_asteroids = 0
      data.each_with_index do |row, y|
        puts "checking row: #{row}, #{y}"
        row.each_with_index do |point, x|
          puts "checking point: #{point}, #{x}"
          if is_meteor?(point)
            observable_asteroids = test_location(x, y, data)
            if max_observable_asteroids < observable_asteroids
              max_observable_asteroids = observable_asteroids
            end
          end
        end
      end

      max_observable_asteroids
    end

    def is_meteor?(point)
      point == '#'
    end

    def test_location(cx, cy, data)
      observable_asteroids = {}
      left, right, top, bottom = 0, 0, 0, 0
      data.each_with_index do |row, y|
        data.each_with_index do |point, x|
          if cx == x && cy == y
            nil # it's current asteroid
          elsif cx == x
            # asteroid is top or bottom?
          elsif cy == y
            # asteroid is left or right
          elsif cx > x

          elsif cx < x
          else
            puts "you bloody elves!"
            raise StandardError
          end
        end
      end

      observable_asteroids.keys.size + left + bottom + right + left
    end

    def might_be_seen(cx, cy, x, y)
      (cx-x).to_f/(cy - y)
    end
  end
end

# bad: 63<, 548>
Day10.part1
