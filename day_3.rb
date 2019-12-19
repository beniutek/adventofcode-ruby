module Day3
  class << self
    def load_input
      IO.readlines('day_3_input').map { |line| line.chomp.split(',') }
    end

    def get_coordinates(arr)
      x, y = [0, 0]
      arrx = []

      arr.each do |i|
        direction, *_length = i.split('')
        length = _length.join.to_i
        case direction
          when 'R'
            length.times { |step| arrx.push([x + step + 1, y]) }
            x += length
          when 'U'
            length.times { |step| arrx.push([x, y + step + 1]) }
            y += length
          when 'L'
            length.times { |step| arrx.push([x - step - 1, y]) }
            x -= length
          when 'D'
            length.times { |step| arrx.push([x, y - step - 1]) }
            y -= length
          else
            raise StandardError('bloody elves');
        end
      end

      arrx
    end

    def part1
      arr1, arr2 = load_input

      corr1 = get_coordinates(arr1)
      corr2 = get_coordinates(arr2)

      get_closest_intersection(corr1, corr2)
    end

    def part2
      arr1, arr2 = load_input

      corr1 = get_coordinates(arr1)
      corr2 = get_coordinates(arr2)

      get_lowest_cost_intersection(corr1, corr2)
    end

    def get_intersections(arr1, arr2)
      arr1 & arr2
    end

    def get_closest_intersection(arr1, arr2)
      intersections = arr1 & arr2

      min = 9999999
      candidate = [0, 0]

      intersections.each do |i|
        x, y = i
        if (x.abs + y.abs) < min
          min = (x.abs + y.abs)
          candidate = [x.abs, y.abs]
        end
      end

      candidate
    end

    def get_lowest_cost_intersection(arr1, arr2)
      intersections = arr1 & arr2

      min = 999999999

      intersections.each do |i|
        index1 = arr1.find_index(i)
        index2 = arr2.find_index(i)

        cost = index1 + index2 + 2
        min = cost if (cost < min)
      end

      min
    end
  end
end