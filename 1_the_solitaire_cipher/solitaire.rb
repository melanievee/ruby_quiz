phrase = "CLEPK HHNIY CFPWH FDFEH"

class Deck
	attr_accessor :deck

	def initialize
		@deck = (1..52).to_a << "A" << "B"
	end

	def move_a
		a_index = deck.index("A")
		move_down(a_index)
	end

	def move_b
		2.times do 
			b_index = deck.index("B")
			move_down(b_index)
		end
	end

	def triple_cut
		a_index = deck.index("A")
		b_index = deck.index("B")
		top_joker = [a_index, b_index].min
		bottom_joker = [a_index, b_index].max
		origdeck = deck.dup
		deck.replace(origdeck[(bottom_joker+1)..-1].concat(origdeck[top_joker..bottom_joker]).concat(origdeck[0..(top_joker-1)]))
	end

	def count_cut
		if deck.last == "A"
			count = 53
		elsif deck.last == "B"
			count = 53
		else
			count = deck.last
		end
		origdeck = deck.dup
		topcut = origdeck[0..(count-1)]
		middle = origdeck[count..(deck.length-2)]
		last = deck.last

		deck.replace([middle, topcut, last].flatten)
	end

	def output_letter
		if deck.first == "A" || deck.first == "B"
			output_card = deck[53]
		else
			output_card = deck[deck.first]
		end

		puts "Deck first: #{deck.first}"
		puts "Deck: #{deck}"
		puts "Output card: #{output_card}"

		if output_card == "A" || output_card == "B"
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
end

def generate_keystream(length)
	keydeck = Deck.new
	keystream = []
	while keystream.length < length do 
		keydeck.move_a
		keydeck.move_b
		keydeck.triple_cut
		keydeck.count_cut
		new_key = keydeck.output_letter
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


mykeystream = generate_keystream(10)
puts "Keystream: #{mykeystream}"

decrypted = phrase
puts "Phrase: #{phrase}"
puts "Decrypted: #{decrypted}"