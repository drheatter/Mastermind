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

	# This method provides an alternate way to check guesses with letters
	# instead of colored text. It's used for CPU player guesses. 
	def cpu_check_guess(guess)
		guess_char_array = guess.split('')
		return_string = ''
		guess_char_array.each_index do |i|
			if guess_char_array[i] == @code[i]
				return_string += "G"
			elsif @code.include?(guess_char_array[i])
				return_string += "W"
			else
				return_string += "R"
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
		@code = generate_code
		@guess_result = nil
		@valid_guess_numbers = ["1", "2", "3", "4", "5", "6"]
		@guess_string = @valid_guess_numbers.sample(4).join("")
		@valid_guess_by_index = []
		@white_numbers = []
		4.times { @valid_guess_by_index.push(["1", "2", "3", "4", "5", "6"]) }
	end

	def generate_code
		code_string = ""
		4.times { code_string += (1 + rand(6)).to_s }
		@code = Code.new(code_string)
	end

	def make_guess
		return @guess_string unless @guess_result
		code_string = ""
		4.times do |i|
			@guess_result[i] == "G" ? 
				code_string += @guess_string[i] : code_string += get_valid_guess(i)
		end
		@guess_string = code_string
		@guess_string
	end

	def update_guess_logic(code)
		@guess_result = code.cpu_check_guess(@guess_string)
		@guess_result.split("").each_index do |i|
			if @guess_result[i] == "R"
				@valid_guess_numbers.delete(@guess_string[i])
			elsif @guess_result[i] == "W"
				@valid_guess_by_index[i].delete(@guess_string[i])
				@white_numbers.push(@guess_string[i]) unless @white_numbers.include?(@guess_string[i])
			end
		end
	end

	private

	def get_valid_guess(i)
		possible_numbers = @valid_guess_numbers & @valid_guess_by_index[i]
		@white_numbers.each do |n|
			if possible_numbers.include?(n)
				@white_numbers.delete(n)
				return n
			end
		end
		possible_numbers.sample.to_s
	end

end

class Game

	def initialize
		@cpu_player = ComputerPlayer.new
	end

	def play
		print_instructions
		loop do
			@cpu_player = ComputerPlayer.new
			human_guesser? ? play_human_guesser : play_cpu_guesser
			break unless play_again?
		end
	end

	private

	def play_cpu_guesser
		code = get_human_code
		cpu_won = false
		4.times do
			puts "The computer is thinking..."
			sleep(3)
			guess = cpu_guess_turn(code)
			cpu_won = true if code.is_correct?(guess)
			break if cpu_won
		end
		cpu_won ? cpu_win_message : human_win_message
	end

	def cpu_guess_turn(code)
		guess  = @cpu_player.make_guess
		puts "CPU's guess is #{guess}."
		puts "Checking their guess: #{code.check_guess(guess)}"
		@cpu_player.update_guess_logic(code)
		guess
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
			break if won
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
		puts "You won! Congrats!"
	end

	def human_loss_message
		puts "Sorry, you lost. The correct code was #{@cpu_player.code.to_s}."
	end

	def cpu_win_message
		puts "The computer won! Better luck next time!"
	end
end


game = Game.new
game.play