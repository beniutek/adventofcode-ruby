require 'digest'

module Day12
  class Moon
    attr_reader :velocity, :position, :name

    def initialize(x, y, z, name)
      @name = name
      @position = [x, y, z]
      @velocity = [0, 0, 0]
    end

    def apply_gravity(moon)
      adjust_velocities(moon)
    end

    def adjust_velocities(moon)
      position.each_with_index do |val, i|
        if val > moon.position[i]
          adjust_velocity(i, -1)
          moon.adjust_velocity(i, 1)
        elsif val < moon.position[i]
          adjust_velocity(i, 1)
          moon.adjust_velocity(i, -1)
        else
          nil
        end
      end
    end

    def adjust_velocity(key, val)
      @velocity[key] += val
    end

    def apply_velocity
      (0..2).map { |i| @position[i] = @position[i] + @velocity[i] }
    end

    def kinetic_energy
      @velocity.map(&:abs).sum
    end

    def potential_energy
      @position.map(&:abs).sum
    end

    def total_energy
      kinetic_energy * potential_energy
    end
  end

  class Space
    attr_reader :moons

    def initialize(moons = [])
      @moons = moons
    end

    def move(steps = 1000)
      steps.times { |i| move_one_step }
    end

    def move_one_step
      moons.combination(2).map { |a, b| a.apply_gravity(b) }

      moons.map(&:apply_velocity)
    end

    def energy
      moons.map(&:total_energy).sum
    end

    def summary
      moons.each do |m|
        puts "Position: #{m.position.to_s} Velocity: #{m.velocity.to_s}"
      end
      nil
    end

    def current_state(dimension)
      moons.map do |moon|
        [moon.position[dimension], moon.velocity[dimension]]
      end
    end

    def velocity
      moons.map(&:velocity)
    end
  end

  class << self
    def part1
      io = Moon.new(-8, -10, 0, 'Io')
      europa = Moon.new(5, 5, 10, 'Europa')
      ganymede = Moon.new(2, -7, 3, 'Ganymede')
      callisto = Moon.new(9, -8, -3, 'Callisto')

      space = Space.new([io, europa, ganymede, callisto])
      space.move(1000)
      space.energy
    end

    def part2
      io = Moon.new(5, 13, -3, 'Io')
      europa = Moon.new(18, -7, 13, 'Europa')
      ganymede = Moon.new(16, 3, 4, 'Ganymede')
      callisto = Moon.new(0, 8, 8, 'Callisto')

      # io = Moon.new(-8, -10, 0, 'Io')
      # europa = Moon.new(5, 5, 10, 'Europa')
      # ganymede = Moon.new(2, -7, 3, 'Ganymede')
      # callisto = Moon.new(9, -8, -3, 'Callisto')

      # io = Moon.new(-1, 0, 2, 'Io')
      # europa = Moon.new(2, -10, -7, 'Europa')
      # ganymede = Moon.new(4, -8, 8, 'Ganymede')
      # callisto = Moon.new(3, 5, -1, 'Callisto')

      space = Space.new([io, europa, ganymede, callisto])
      start_x_state = space.current_state(0).dup
      start_y_state = space.current_state(1).dup
      start_z_state = space.current_state(2).dup

      count_x, count_y, count_z = 0, 0, 0
      x, y, z = true, true, true

      while x || y || z
        space.move_one_step

        if x
          count_x += 1
          x = false if space.current_state(0) == start_x_state
        end

        if y
          count_y += 1
          y = false if space.current_state(1) == start_y_state
        end

        if z
          count_z += 1
          z = false if space.current_state(2) == start_z_state
        end
      end

      [count_x, count_y, count_z].reduce(1, :lcm)
    end
  end
end

space = Day12.part2
