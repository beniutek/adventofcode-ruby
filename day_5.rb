module Day5
  class Intcode
    INITIAL_VALUE = 5
    def initialize
      @position = 0
      load_data
      @initial_data = @data.dup
    end

    def run_computation
    # Day5::Intcode.new.run_computation
      while @data[@position] != 99
        position_step = 0
        instruction = @data[@position].to_s.rjust(5, '0').split('')
        puts "======================================================================="
        puts "INSTRUCTION: #{instruction}"
        puts "CURENT POSITION: #{@position}"
        third_param_mode, second_param_mode, first_param_mode, *_opcode = instruction
        opcode = _opcode.join('')
        modes = [first_param_mode, second_param_mode]
        puts "OPCODE: #{opcode}"
        if opcode == '01'
          position_step = 4
          perform(:+, modes: modes)
        elsif opcode == '02'
          position_step = 4
          perform(:*, modes: modes)
        elsif opcode == '03'
          position_step = 2
          store_value(@position + 1, INITIAL_VALUE)
          p "saved value #{INITIAL_VALUE} into #{@data[@position+1]} : #{@data[@data[@position + 1]]}"
        elsif opcode == '04'
          position_step = 2
          puts get_value(@position + 1, mode: first_param_mode)
        elsif opcode == '05'
          position_step = 0
          @position = new_pointer_value(:>, modes, 0, @position + 3)
          puts "new pointer value: #{@position}"
        elsif opcode == '06'
          position_step = 0
          @position = new_pointer_value(:==, modes, 0, @position + 3)
          puts "new pointer value: #{@position}"
        elsif opcode == '07'
          position_step = 4
          val = get_value_to_store(:<, modes)
          store_value(@position + 3, val)
        elsif opcode == '08'
          position_step = 4
          val = get_value_to_store(:==, modes)
          store_value(@position + 3, val)
        else
          puts "\nbloody elves!\n"
          raise StandardError 
        end

        @position += position_step
      end
    end

    def provide_output(mode)
      i = @data[@position]
      mode == 0 ? @data[i] : i
    end

    def store_value(position, value)
      @data[@data[position]] = value
    end

    def get_value_to_store(condition, modes)
      first_param = get_value(@position + 1, mode: modes[0])
      second_param = get_value(@position + 2, mode: modes[1])
      first_param.send(condition, second_param) ? 1 : 0
    end

    def new_pointer_value(condition, modes = [], param = 0, default_value = 3)
      first_param = get_value(@position + 1, mode: modes[0])
      second_param = get_value(@position + 2, mode: modes[1]) 

      puts "#{first_param} #{condition} #{param} ?"

      first_param.send(condition, param) ? second_param : default_value
    end
  
    def perform(instruction, modes: [])
      param1 = get_value(@position + 1, mode: modes[0])
      param2 = get_value(@position + 2, mode: modes[1])
      index3 = @data[@position + 3]
      x = param1.send(instruction, param2)
      puts "#{param1} #{instruction} #{param2} = #{x}"
      @data[index3] = x
      puts "#{x} saved into #{index3}"
    end

    def get_value(position, mode: '0')
      x = mode == '0' ? get_value_position_mode(position) : get_value_immediate_mode(position)
      puts "GET VALUE: #{x}"
      x
    end

    def get_value_position_mode(position)
      @data[@data[position]]
    end

    def get_value_immediate_mode(position)
      @data[position]
    end

    def get_param(mode, index)
      p "GET PARAM: "
      p "mode: #{mode} position: #{@data[@position + index]}"
      i = @data[@position + index]
      x = mode == '0' ? @data[i] : i
      p "returning: #{x}"
      p "----------------"
      x
    end

    def load_data
      @data = IO.read('day_5_input').chomp.split(',').map(&:to_i)
    end

    def restore_memory
      @position = 0
      @data = @initial_data.dup
    end
  end
end