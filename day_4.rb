module Day4
  RANGE = 168630..718098

  # It is a six-digit number.
  # The value is within the range given in your puzzle input.
  # Two adjacent digits are the same (like 22 in 122345).
  # Going from left to right, the digits never decrease; 
  # they only ever increase or stay the same (like 111123 or 135679)
  class << self
    def part1
      test = /\d*((11)|(22)|(33)|(44)|(55)|(66)|(77)|(88)|(99)|(00))\d*/
      count = 0
      ca = []
      RANGE.each do |item|
        string = item.to_s
        next if is_decreasing(string) || !string.match(test)
        ca.push item
        count += 1
      end
      ca
    end

    def part2
      count = 0
      ca = []
      RANGE.each do |item|
        string = item.to_s
        next if is_decreasing(string) || weird_aoc_rule(string)
        ca.push(item)
        count += 1
      end
      ca
    end 

    def string_includes_arr_element?(string, arr)
      arr.any? { |x| string.include?(x) }
    end

    def weird_aoc_rule(string)
      # valid = [
      #   '11','22','33','44','55','66','77','88','99','00'
      # ]
      # invalid = [
      #   '111','222','333','444','555','666','777','888','999','000',
      #   '1111','2222','3333','4444','5555','6666','7777','8888','9999','0000',
      # ]
      # super_invalid = [
      #   '111111','222222','333333','444444','555555','666666','777777','888888','999999','000000',
      # ]

      # has_valid = string_includes_arr_element?(string, valid)
      # has_invalid = string_includes_arr_element?(string, invalid)
      # has_super_invalid = string_includes_arr_element?(string, super_invalid)

      # !has_super_invalid &&

      # (
      #   (has_valid && has_invalid) ||
      #   (has_valid && !has_invalid)
      # ) &&
      # !has_super_invalid

      count = 1
      counts = []
      current = nil

      string.split('').each_with_index do |i, index|
        next if index == 0
        if i == string[index - 1]
          count += 1
          counts.push(count) if string.length == index + 1
        else
          counts.push(count)
          count = 1
        end
      end
      
      has_doubles = false
      # has_more_than_doubles = false

      counts.each do |occurences|
        if occurences == 2
          has_doubles = true
        end
      end

      !has_doubles
    end


    def is_decreasing(string)
      string[0].to_i > string[1].to_i ||
      string[1].to_i > string[2].to_i ||
      string[2].to_i > string[3].to_i ||
      string[3].to_i > string[4].to_i ||
      string[4].to_i > string[5].to_i
    end
  end
end