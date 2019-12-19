
# require './day_1.rb'
# require './day_2.rb'
# require './day_3.rb'
# require './day_4.rb'
# require './day_5.rb'
 require './day_6.rb'

# Day2.part1
# Day2.part2
#
# intcode = Day2::Intcode.new
# intcode.run_computation
# intcode.fo


      # puts 'start'
      # arr1, arr2 = Day3.load_input

      # corr1 = Day3.get_coordinates(arr1)
      # corr2 = Day3.get_coordinates(arr2)

      # puts 'nearl enddd'
      # closest = Day3.get_lowest_cost_intersection(corr1, corr2)


def foo(x)
  x = x.to_i
  while x < 10
    if x == 1
      puts "1"
      x += 1
    elsif x ==5
      puts "5"
      return x
    end
    puts "nex loop #{x}"
    x += 1
  end
  puts "out of loop! #{x}"
  x
end
