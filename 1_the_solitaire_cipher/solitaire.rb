phrase = "CLEPK HHNIY CFPWH FDFEH"

class Deck
	attr_accessor :deck

	def initialize
		@deck = (1..52).to_a << "A" << "B"
	end

	def get_key
		move_a
		move_b
		triple_cut
		count_cut
		get_output_letter
	end

	private

		def move_a
			move_down(deck.index("A"))
		end

		def move_b
			2.times do 
				move_down(deck.index("B"))
			end
		end

		def triple_cut
			top_joker = [deck.index("A"), deck.index("B")].min
			bottom_joker = [deck.index("A"), deck.index("B")].max
			topcut = deck[0..(top_joker-1)]
			middle = deck[top_joker..bottom_joker]
			bottomcut = deck[(bottom_joker+1)..-1]
			deck.replace([bottomcut,middle,topcut].flatten)
		end

		def count_cut
			if is_joker(deck.last)
				count = 53
			else
				count = deck.last
			end
			topcut = deck[0..(count-1)]
			middle = deck[count..(deck.length-2)]
			last = deck.last
			deck.replace([middle, topcut, last].flatten)
		end

		def get_output_letter
			if is_joker(deck.first)
				output_card = deck[53]
			else
				output_card = deck[deck.first]
			end

			if is_joker(output_card)
				nil
			else
				to_letter(output_card)
			end
		end

		def move_down(index)
			if index == deck.length-1
				deck.rotate!(deck.length-1)
				index = 0
			end
			deck[index], deck[index+1] = deck[index+1], deck[index]
		end

		def is_joker(card)
			if card == "A" || card == "B"
				true 
			else
				false
			end
		end
end

class Encrypter
	attr_accessor :input 
	attr_accessor :output 

	def initialize(message)
		@input = message
	end

	def encrypt
		keystream = generate_keystream		
		prepare_input

	end

	def decrypt
	end

	private

		def prepare_input
			input.upcase!.gsub!(/[^A-Z]/,'')
			input.concat("X"*(input.length/5))
		end

		def generate_keystream
			length = input.length
			puts "Length: #{input.length}"
			keydeck = Deck.new
			keystream = []
			while keystream.length < length do 
				new_key = keydeck.get_key
				keystream << new_key unless new_key.nil?
			end
			keystream
		end




end

def generate_keystream(length)
	keydeck = Deck.new
	keystream = []
	while keystream.length < length do 
		new_key = keydeck.get_key
		keystream << new_key unless new_key.nil?
	end
	keystream
end

def to_number(letter)
	letter.ord-64
end

def to_letter(number)
	if number > 26
		(number-26+64).chr
	else
		(number+64).chr
	end
end

decrypted = Encrypter.new("Code in Ruby, live longer!").encrypt
puts "Phrase: #{phrase}"
puts "Decrypted: #{decrypted}"

