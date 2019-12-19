module Day8
  WIDTH = 25
  HEIGHT = 6

  class << self
    def load_data
      IO.read('input_day8').chomp.split('')
    end

    Point = Struct.new(:x, :y)

    def process_data
      data = load_data
      layers = []
      size = WIDTH * HEIGHT
      current_layer = []

      data.each_with_index do |x, index|
        current_layer << x.to_i
        if (index + 1) % size == 0
          layers << current_layer
          current_layer = []
        end
      end

      layers
    end

    def layer_with_least_zeros(layers)
      winning_layer = nil
      zeros = 9999999999

      layers.each do |layer|
        current_zeros = layer.count { |x| x == 0 }
        if current_zeros < zeros
          zeros = current_zeros
          winning_layer = layer
        end
      end

      winning_layer
    end

    def get_pixel_color(index, layers)
      current_pixel_color = 2

      layers.reverse_each do |layer|
        pixel_color = layer[index]
        current_pixel_color = pixel_color if pixel_color != 2
      end

      current_pixel_color
    end


    def draw_layer(layer)
      start = 0
      stop = 24

      (0..(HEIGHT-1)).each do |y|
        start = y*25
        stop = 24+start

        draw_row(layer[start..stop])
      end
      nil
    end

    def draw_row(row)
      string = ""

      row.each do |pixel|
        string += get_black_box if pixel == 0
        string += get_white_box if pixel == 1
      end

      puts string
    end

    def get_white_box
      "\u25FD"
    end

    def get_black_box
      "\u25FE"
    end

    def part2
      layers = process_data
      end_layer = Array.new(HEIGHT*WIDTH)

      end_layer.each_with_index do |i, index|
        end_layer[index] = get_pixel_color(index, layers)
      end

      draw_layer end_layer
    end

    def part1
      layers = process_data
      layer = layer_with_least_zeros(layers)
      ones, twos = 0, 0

      layer.each do |i|
        ones += 1 if i == 1
        twos += 1 if i == 2
      end

      ones * twos
    end
  end
end
