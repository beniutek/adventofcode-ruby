module Day9
  class Intcode
    attr_reader :debug
    def initialize(signal_input: nil, phase_input: nil, data: nil, store_phase_input: true, debug: false)
      @signal_input = signal_input
      @phase_input = phase_input
      @store_phase_input = store_phase_input
      @position = 0
      @debug = debug
      @relative_base = 0
      @data = data || load_data
      @output = nil
      @halt = false
      raise StandardError if @data.nil?
    end

    def run_computation
      if @halt
        puts "\nThe damn thing is stuck!\n"
        raise StandardError;
      end

      while @data[@position] != 99
        instruction = @data[@position].to_s.rjust(5, '0')
        third_param_mode, second_param_mode, first_param_mode, opcode = instruction[0], instruction[1], instruction[2], instruction[3..4]
        modes = [first_param_mode, second_param_mode, third_param_mode]

        if debug
          puts "INSTRUCTION: #{instruction}"
          puts "OP: #{opcode}"
          puts "POSITION: #{@position}"
        end

        if opcode == '01'
          perform(:+, modes: modes)
          increment_position(4)
        elsif opcode == '02'
          perform(:*, modes: modes)
          increment_position(4)
        elsif opcode == '03'
          store_value(@position + 1, get_input_to_store, first_param_mode)
          increment_position(2)
        elsif opcode == '04'
          @output = get_value(@position + 1, mode: first_param_mode)
          increment_position(2)
          puts "04: RET VAL: #{@output}" if debug
          return @output
        elsif opcode == '05'
          @position = new_pointer_value(:>, modes, 0, @position + 3)
          puts "new position: #{@position}" if debug
        elsif opcode == '06'
          @position = new_pointer_value(:==, modes, 0, @position + 3)
          puts "new position: #{@position}" if debug
        elsif opcode == '07'
          val = get_value_to_store(:<, modes)
          store_value(@position + 3, val, third_param_mode)
          increment_position(4)
        elsif opcode == '08'
          val = get_value_to_store(:==, modes)
          store_value(@position + 3, val, third_param_mode)
          increment_position(4)
        elsif opcode == '09'
          val = get_value(@position + 1, mode: first_param_mode)
          @relative_base += val
          increment_position(2)
        else
          puts "\nbloody elves!\n"
          raise StandardError
        end
      end

      @halt = true
      @output
    end

    def increment_position(step)
      @position += step
    end

    def halted?
      @halt
    end

    def restart!
      @halt = false
    end

    def set_signal_input(input = nil)
      @signal_input = input
    end

    def set_phase_input(input = nil)
      @phase_input = input
    end

    def get_input_to_store
      if @store_phase_input
        @store_phase_input = false
        @phase_input
      else
        @signal_input
      end
    end

    def store_value(position, value, mode)
      puts "store val: #{value} at #{@data[position]}" if debug
      if mode == '0'
        @data[@data[position]] = value
      else
        relative_position = @data[position] + @relative_base
        @data[relative_position] = value
      end
    end

    def get_value_to_store(condition, modes)
      first_param = get_value(@position + 1, mode: modes[0])
      second_param = get_value(@position + 2, mode: modes[1])
      first_param.send(condition, second_param) ? 1 : 0
    end

    def new_pointer_value(condition, modes = [], param = 0, fallback_value = nil)
      first_param = get_value(@position + 1, mode: modes[0])
      second_param = get_value(@position + 2, mode: modes[1])

      first_param.send(condition, param) ? second_param : fallback_value
    end

    def perform(instruction, modes: [])
      param1 = get_value(@position + 1, mode: modes[0])
      param2 = get_value(@position + 2, mode: modes[1])
      index3 = modes[2] == '0' ? @data[@position + 3] : @data[@position+3] + @relative_base

      @data[index3] = param1.send(instruction, param2)
      puts "PERFORM #{param1} #{instruction} #{param2} = #{@data[index3]} at #{index3}" if debug
    end

    def get_value(position, mode: '0')
      case mode
      when '0' then get_value_position_mode(position)
      when '1' then get_value_immediate_mode(position)
      when '2' then get_value_relative_mode(position)
      else
        puts "\nbloody elves!\n"
        raise StandardError
      end
    end

    def get_value_relative_mode(position)
      relative_position = @data[position] + @relative_base
      @data[relative_position] || 0
    end

    def get_value_position_mode(position)
      @data[@data[position]] || 0
    end

    def get_value_immediate_mode(position)
      @data[position] || 0
    end

    def load_data
      IO.read('input_day9').chomp.split(',').map(&:to_i)
    end
  end
end

intcode = Day9::Intcode.new(signal_input: 2, store_phase_input: false)

output = 0
while !intcode.halted?
  output = intcode.run_computation
  intcode.set_signal_input(output)
end

output
