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

	def initialize(message)
		@input = message
	end

	def encrypt
		prepare_input
		keystream = generate_keystream		
		input_numbers = @input.split('').collect { |letter| to_number(letter) }
		keystream_numbers = keystream.split('').collect { |letter| to_number(letter) }
		sum = [input_numbers, keystream_numbers].transpose.map {|v| v.reduce(:+)}
		sum.collect { |number| to_letter(number) }.join
	end

	def decrypt
		prepare_input
		input_numbers = @input.split('').collect { |letter| to_number(letter) }
		keystream = generate_keystream		
		keystream_numbers = keystream.split('').collect { |letter| to_number(letter) }
		difference = [input_numbers, keystream_numbers].transpose.map {|v| v.reduce(:-)}
		difference.map! { |element| element<=0 ? element+26 : element}
		difference.collect { |number| to_letter(number) }.join
	end

	private

		def prepare_input
			@input = @input.upcase.gsub(/[^A-Z]/,'')		
			add_x = (@input.length.modulo(5)).modulo(5)
			@input.concat("X"*add_x)
		end

		def generate_keystream
			keydeck = Deck.new
			keystream = []
			while keystream.length < @input.length do 
				new_key = keydeck.get_key
				keystream << new_key unless new_key.nil?
			end
			keystream.join
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

encrypted = Encrypter.new("CODEI NRUBY LIVEL ONGER").encrypt
puts "Encrypted: #{encrypted}"
decrypted = Encrypter.new(encrypted).decrypt
puts "Decrypted: #{decrypted}"
decrypted = Encrypter.new("CLEPK HHNIY CFPWH FDFEH").decrypt
puts "Decrypted: #{decrypted}"
decrypted = Encrypter.new("ABVAW LWZSY OORYK DUPVH").decrypt
puts "Decrypted: #{decrypted}"




