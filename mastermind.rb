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


#test stuff
test_code = Code.new('1234')
puts test_code.check_guess('1234')
puts test_code.check_guess('1111')
puts test_code.check_guess('6526')
puts test_code.is_correct?('1234')
puts test_code.is_correct?('1222')