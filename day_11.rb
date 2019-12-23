require './day_9'

module Day11
  class Robot
    ORIENTATIONS = { N: :N, W: :W, E: :E, S: :S }

    attr_reader :position_history

    def initialize(x = nil, y = nil)
      @position = [y || 0,  x || 0]
      @orientation = ORIENTATIONS[:N]
      @position_history = []
    end

    def x
      @position[1]
    end

    def y
      @position[0]
    end

    def current_color(panel)
      panel[y][x]
    end

    def paint_panel(input, panel)
      panel[y][x] = input
    end

    def move_forward
      case @orientation
      when :N then @position = [y - 1, x]
      when :W then @position = [y, x + 1]
      when :S then @position = [y + 1, x]
      when :E then @position = [y, x - 1]
      else
        raise StandardError
      end
    end

    def move_robot(input)
      if turn_left?(input)
        case @orientation
        when :N then turn! :W
        when :W then turn! :S
        when :S then turn! :E
        when :E then turn! :N
        else
          raise StandardError
        end
      else
        case @orientation
        when :N then turn! :E
        when :E then turn! :S
        when :S then turn! :W
        when :W then turn! :N
        else
          raise StandardError
        end
      end
      save_current_position
      move_forward
    end

    def save_current_position
      @position_history << @position
    end

    def facing?(direction)
      @orientation == ORIENTATIONS[direction]
    end

    def turn!(direction)
      @orientation = direction
    end

    def turn_left?(input)
      input != 0
    end
  end

  class << self
    def load_data
      IO.read('day11_input').chomp.split(',').map(&:to_i)
    end

    def part1
      panel = Array.new(1000) { Array.new(1000, 0) }
      intcode = Day9::Intcode.new(store_phase_input: false, data: load_data)
      robot = Robot.new(500, 500)
      input = 0
      while !intcode.halted?
        intcode.set_signal_input(input)
        color = intcode.run_computation
        if !intcode.halted?
          direction = intcode.run_computation
          robot.paint_panel(color, panel)
          robot.move_robot(direction)
          input = robot.current_color(panel)
        end
      end
      robot
    end

    def part2
      panel = Array.new(10) { Array.new(10, 0) }
      panel[0][0] = 1
      intcode = Day9::Intcode.new(store_phase_input: false, data: load_data)
      robot = Robot.new(0, 0)
      input = 1
      while !intcode.halted?
        intcode.set_signal_input(input)
        color = intcode.run_computation
        robot.paint_panel(color, panel)

        if !intcode.halted?
          view_drawing panel
          direction = intcode.run_computation
          robot.move_robot(direction)
          input = robot.current_color(panel)
        end
      end
      view_drawing panel
    end

    def view_drawing(panel)
      panel.each do |row|
        mapped = row.map { |point| point == 1 ? get_white_box : get_black_box }
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
end
