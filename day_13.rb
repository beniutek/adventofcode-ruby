require './day_9'

module Day13
  class Screen
    def initialize(x = 25, y = 40)
      @screen = Array.new(y) { Array.new(x) { nil } }
    end

    def draw_tiles(input)
      x, y, id = input

      @screen[x][y] = id
    end

    def count_tiles
      @screen.map { |row| row.count(2) }.sum
    end

    def draw_screen
      @screen.each do |row|
        mapped = row.map { |point| point != 0 ? get_white_box : get_black_box }
        puts mapped.join('').to_s
      end
      nil
    end

    def get_white_box
      "\u25FD"
    end

    def get_black_box
      "\u25FE"
    end
  end

  Paddle = Struct.new(:x, :y, :id)
  Ball = Struct.new(:x, :y, :id)

  class Arcade
    attr_reader :screen

    def initialize
      @screen = Screen.new
      @ball = Ball.new
      @paddle = Paddle.new
    end

    def consume_input(input)
      x, y, id = input
      puts "consuming input: #{input}"
      case id
      when 3
        update_paddle(x, y)
        @screen.draw_tiles(input)
      when 4
        update_ball(x, y)
        @screen.draw_tiles(input)
      else
        @screen.draw_tiles(input)
      end
    end

    def joystick_output
      return 0 unless @ball.x && @ball.y && @paddle.x && @paddle.y
      return 0 if @ball.x == @paddle.x
      return 1 if @ball.x > @paddle.x
      return -1
    end

    def update_ball(x, y)
      puts "update ball: #{x} #{y}"
      @ball.x = x
      @ball.y = y
    end

    def update_paddle(x, y)
      puts "update paddle: #{x} #{y}"
      @paddle.x = x
      @paddle.y = y
    end
  end

  class << self
    def part1
      data = load_data
      data[0] = 2
      intcode = Day9::Intcode.new(data: data)
      arcade = Arcade.new
      score = 0

      while !intcode.halted?
        inner_count = 0
        output = []

        while !intcode.halted? && inner_count < 3
          output << intcode.run_computation
          inner_count += 1
        end

        if output.size == 3
          if output[0] == -1 && output[1] == 0
            score = output[2]
          else
            arcade.consume_input(output)
          end
        end

        intcode.set_signal_input(arcade.joystick_output)

        arcade.screen.draw_screen
      end

      score
    end

    def load_data
      IO.read('day13_input').chomp.split(',').map(&:to_i)
    end
  end
end

x = Day13.part1
