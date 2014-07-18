# Secret Santa: Ruby Quiz #2 (http://rubyquiz.com/quiz2.html)

# Secret Santa Rules:
# -Can't get yourself
# -Can't get someone with your same last name 

# Fed list on STDIN, like below: 
# Luke Skywalker   <luke@theforce.net>
# Leia Skywalker   <leia@therebellion.org>
# Toula Portokalos <toula@manhunter.org>
# Gus Portokalos   <gus@weareallfruit.net>
# Bruce Wayne      <bruce@imbatman.com>
# Virgil Brigman   <virgil@rigworkersunion.org>
# Lindsey Brigman  <lindsey@iseealiens.net>

# Name Format: 
# FIRST_NAME space FAMILY_NAME space <EMAIL_ADDRESS> newline

# Output:
# Email the person and tell them who their person is

class Person
	attr_accessor :firstname, :lastname, :email, :giftee

	def initialize(firstname, lastname, email)
		@firstname = firstname
		@lastname = lastname
		@email = email 
	end

	def info
		firstname + " " + lastname + " " + email
	end

	def assign_giftee(person)
		@giftee = person 
	end

	def valid_santa?
		if self.lastname == giftee.lastname
			false
		else
			true
		end
	end
end

def assign_santas(people)
	giftees = people.shuffle
	puts "PAIRS: "
	people.each_with_index do |person, i| 
		person.assign_giftee(giftees[i])
		puts "#{person.info} drew #{giftees[i].info}"
	end
end

def check_santas(people)
	valid = true
	people.each do |person|
		valid = valid & person.valid_santa?
	end
	valid
end

puts "\n\nWelcome to Secret Santa!  Please input names in the following format: \nFIRST_NAME space FAMILY_NAME space <EMAIL_ADDRESS>, pressing return after each.  \nType q and hit enter to quit."

people = []
while true
	input = gets.chomp
	break if input.downcase == "q"
	if input.split.length != 3
		puts "Oops, there seems to have been an input error.  Please be sure you follow the format specified above."
	else
		people << Person.new(input.split[0], input.split[1], input.split[2])
	end
end

iter = 1
begin
	puts "Iteration number #{iter}"
	assign_santas(people)
	iter +=1
end until check_santas(people)
