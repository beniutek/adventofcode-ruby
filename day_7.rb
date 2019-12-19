module Day7
  class Intcode
    def initialize(signal_input: nil, phase_input: nil, data: nil)
      @signal_input = signal_input
      @phase_input = phase_input
      @store_phase_input = true
      @position = 0
      @data = data || load_data
      @output = nil
      @halted = false
      raise StandardError if @data.nil?
    end

    def run_computation
      if @halted
        puts "\nThe damn thing is stuck!\n"
        raise StandardError;
      end

      while @data[@position] != 99
        position_step = 0
        instruction = @data[@position].to_s.rjust(5, '0').split('')
        third_param_mode, second_param_mode, first_param_mode, *_opcode = instruction
        opcode = _opcode.join('')
        modes = [first_param_mode, second_param_mode]

        if opcode == '01'
          position_step = 4
          perform(:+, modes: modes)
        elsif opcode == '02'
          position_step = 4
          perform(:*, modes: modes)
        elsif opcode == '03'
          position_step = 2
          store_value(@position + 1, get_input_to_store)
        elsif opcode == '04'
          position_step = 2
          @output = get_value(@position + 1, mode: first_param_mode)
          puts "04 code returning: #{@output}"
          @position += position_step
          return @output
        elsif opcode == '05'
          position_step = 0
          @position = new_pointer_value(:>, modes, 0, @position + 3)
        elsif opcode == '06'
          position_step = 0
          @position = new_pointer_value(:==, modes, 0, @position + 3)
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

      @halted = true
      @output
    end

    def halted?
      @halted
    end

    def restart!
      @halted = false
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

      first_param.send(condition, param) ? second_param : default_value
    end

    def perform(instruction, modes: [])
      param1 = get_value(@position + 1, mode: modes[0])
      param2 = get_value(@position + 2, mode: modes[1])
      index3 = @data[@position + 3]

      @data[index3] = param1.send(instruction, param2)
    end

    def get_value(position, mode: '0')
      mode == '0' ? get_value_position_mode(position) : get_value_immediate_mode(position)
    end

    def get_value_position_mode(position)
      @data[@data[position]]
    end

    def get_value_immediate_mode(position)
      @data[position]
    end

    def load_data
      IO.read('input_day7').chomp.split(',').map(&:to_i)
    end
  end

  class << self
    def load_data
      IO.read('input_day7').chomp.split(',').map(&:to_i)
    end

    def part1
      max_result = 0
      best_settings = nil
      initial_signal_input = 0

      [0,1,2,3,4].permutation.each do |settings|
        result = send_signal_to_thruster(settings, initial_signal_input = 0)
        initial_signal_input = result
        if result > max_result
          max_result = result
          best_settings = settings
        end
      end

      [max_result, best_settings]
    end

    def send_signal_to_thruster(settings, initial_signal_input = 0)
      signal_input = initial_signal_input

      settings.split('').each do |input|
        amp = Intcode.new(signal_input: signal_input, phase_input: input.to_i)
        signal_input = amp.run_computation
      end

      signal_input
    end

    def part2
      max_result = 0
      best_settings = nil

      [5,6,7,8,9].permutation.each do |settings|
        amplifiers = settings.map { |input| Intcode.new(phase_input: input) }

        signal_input = 0

        count = 0

        while amplifiers.map(&:halted?).all?
          amplifiers.each do |amplifier|
            amplifier.set_signal_input(signal_input.to_i)
            signal_input = amplifier.run_computation
          end
        end

        if signal_input > max_result
          max_result = signal_input
          best_settings = settings
        end
      end

      [max_result, best_settings]
    end
  end
end
