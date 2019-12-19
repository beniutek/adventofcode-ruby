module Day6
  class << self
    def load_data
      IO.readlines('day_6_input')
    end

    def part
      data = load_data
      galaxy = {}

      data.each do |line|
        center, orbiter = line.chomp.split(')')
        stars = galaxy[center] ? galaxy[center] : []

        galaxy[center] = [orbiter, *stars]
      end

      reversed_galaxy = reverse_galaxy(galaxy)

      count_orbits(reversed_galaxy)
    end

    def reverse_galaxy(galaxy)
      new_galaxy = {}

      galaxy.each do |key, stars|
        stars.each do |star|
          new_galaxy[star] = get_indirect_stars(star, galaxy)
        end
      end

      new_galaxy
    end

    def get_indirect_stars(star, galaxy)
      stars = []
      galaxy.each do |key, val|
        if val.include?(star)
          stars.push(*get_indirect_stars(key, galaxy), key)
        end
      end
      stars
    end

    def count_orbits(galaxy)
      count = 0

      galaxy.each do |_, stars|
        count += stars.size
      end

      count
    end


    def part2
      data = load_data
      galaxy = {}

      data.each do |line|
        center, orbiter = line.chomp.split(')')
        stars = galaxy[center] ? galaxy[center] : []

        galaxy[center] = [orbiter, *stars]
      end

      reversed_galaxy = reverse_galaxy(galaxy)


      find_path_length('YOU', 'SAN', reversed_galaxy)
    end

    def find_path_length(beginning, destination, galaxy)
      common_stars = galaxy[beginning] & galaxy[destination]
      (galaxy[beginning] - common_stars).size + (galaxy[destination] - common_stars).size
    end
  end
end
