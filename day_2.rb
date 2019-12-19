module Day2
  class Intcode
    attr_reader :position, :data, :initial_data

    def initialize
      @position = 0
      load_data
      @initial_data = @data.dup
    end

    def noun
      @data[1]
    end

    def verb
      @data[2]
    end

    def run_computation
      while data[position] != 99
        if data[position] == 1
          perform(:+)
        elsif data[position] == 2
          perform(:*)
        else
          puts "something went terribly wrong!"
          raise StandardError.new({ data: data, position: position })
        end

        @position += 4
      end

      data[0]
    end

    def fo(output = 19690720)
      noun_value = 0
      verb_value = 0

      while run_computation != output
        restore_memory   

        return if verb_value == 99 && noun_value == 99

        if noun_value == 99
          verb_value += 1
          noun_value = 0
        end

        noun_value += 1
        @data[1] = noun_value
        @data[2] = verb_value   
      end

      [output, noun, verb]
    end

    def restore_memory
      @position = 0
      @data = initial_data.dup
    end
  
    def perform(instruction)
      index1 = data[position + 1]
      index2 = data[position + 2]
      index3 = data[position + 3]

      data[index3] = data[index1].send(instruction, data[index2])
    end

    def load_data
      @data = IO.read('day_2_input').chomp.split(',').map(&:to_i)
    end
  end
end