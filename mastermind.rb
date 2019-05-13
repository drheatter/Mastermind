class String

	def red
		"\e[31m#{self}\e[0m"
	end

	def green;
		"\e[32m#{self}\e[0m" 
	end
end

class Code

	def initialize(code)
		@code = code
	end

	def is_correct?(guess)
		@code == guess ? true : false
	end

	def check_guess(guess)
		guess_char_array = guess.split('')
		return_string = ''
		guess_char_array.each_index do |i|
			if guess_char_array[i] == @code[i]
				return_string += guess_char_array[i].green
			elsif @code.include?(guess_char_array[i])
				return_string += guess_char_array[i]
			else
				return_string += guess_char_array[i].red
			end
		end
		return_string
	end
end

class ComputerPlayer
	attr_reader :code

	def initialize
		@code = generate_code
	end

	private

	def generate_code()
		code = ""
		4.times { code += (1 + rand(6)).to_s }
		code
	end
end

class Game

	def initialize
		@cpu_player = ComputerPlayer.new
	end

	def play
		print_instructions
		4.times do
			guess = get_guess
		end
	end

	private

	def print_instructions
		puts "Welcome to Mastermind!" 
		puts "The computer will think of a code of four digits between 1 and 6."
		puts "Your challenge is to guess it in four tries."
		puts "After each guess, you will see a response."
		puts "Green numbers in this response are correct."
		puts "White numbers are in the code, but in a different position."
		puts "Red numbers aren't in the code at all."
		puts "Now, let's play!"
	end

	def get_guess
		loop do
			puts "Guess a code (four digits between 1 and 6)"
			input = gets.chomp
			return input if input.match(/^[1-6]{4}$/)
			puts "Invalid input, try again."
		end
	end
end


#test stuff
test_game = Game.new
test_game.play