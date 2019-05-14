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

	def to_s
		@code
	end
end

class ComputerPlayer
	attr_reader :code

	def initialize
		generate_code
	end

	def generate_code()
		code_string = ""
		4.times { code_string += (1 + rand(6)).to_s }
		@code = Code.new(code_string)
	end
end

class Game

	def initialize
		@cpu_player = ComputerPlayer.new
	end

	def play
		print_instructions
		loop do
			human_guesser? ? play_human_guesser : play_cpu_guesser
			break unless play_again?
		end
	end

	private

	def play_cpu_guesser
		code = get_human_code
		puts code
	end

	def get_human_code
		input = ""
		loop do
			puts "Enter a code consisting of 4 digits between 1 and 6."
			input = gets.chomp
			break if input.match(/^[1-6]{4}$/)
			print "Invalid code selection. "
		end
		Code.new(input)
	end

	def human_guesser?
		input = ""
		loop do
			puts "Would you like to be the guesser or the codemaker? (Use numeric inputs to answer.)"
			puts "1 - Guesser"
			puts "2 - Codemaker"
			input = gets.chomp
			break if input.match(/^[12]$/)
			print "Invalid input. "
		end
		input == "1" ? true : false
	end

	def play_again?
		input = ""
		loop do
			puts "Would you like to play again? (Y/N)"
			input = gets.chomp
			break if input.match(/^[ynYN]$/)
			print "Invalid input. "
		end
		input.downcase == "y" ? true : false
	end

	def play_human_guesser
		won = false
		@cpu_player.generate_code
		4.times do
			guess = get_guess
			puts "Response: #{@cpu_player.code.check_guess(guess)}"
			won = true if @cpu_player.code.is_correct?(guess)
			break if @cpu_player.code.is_correct?(guess)
		end
		won ? human_win_message : human_loss_message
	end

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

	def human_win_message
		puts "You won! Good job!"
	end

	def human_loss_message
		puts "Sorry, you lost. The correct code was #{@cpu_player.code.to_s}."
	end
end


game = Game.new
game.play

# Test stuff
#test_code = Code.new('1234')
#test_match = test_code.check_guess('3532')
#puts test_match.split('')