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

require 'net/smtp'

def send_email(to,opts={})
  opts[:server]      ||= 'smtp.gmail.com'
  opts[:from]        ||= ENV['GMAIL_USERNAME']
  opts[:from_alias]  ||= 'Santa Claus'
  opts[:subject]     ||= "Your Secret Santa has been picked!"
  opts[:santa]       ||= "Error!  Contact Melanie!"
  opts[:port]				 ||= 587
  opts[:domain]			 ||= "gmail.com"
  opts[:password]		 ||= ENV['GMAIL_PASSWORD']

  msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

Dear #{opts[:recipient]},

Secret Santas have been selected!  

You drew #{opts[:santa]}.  

Happy Gifting!
Melanie
END_OF_MESSAGE

	smtp = Net::SMTP.new opts[:server], opts[:port]
	smtp.enable_starttls
	smtp.start(opts[:domain], opts[:from], opts[:password], :login) do
	  smtp.send_message msg, opts[:from], to
	end
end

class Person
	attr_accessor :firstname, :lastname, :email, :giftee

	def initialize(firstname, lastname, email)
		@firstname = firstname
		@lastname = lastname
		@email = email.gsub!("<","").gsub!(">","")
	end

	def fullname
		firstname + " " + lastname
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
	# puts "PAIRS: "
	people.each_with_index do |person, i| 
		person.assign_giftee(giftees[i])
		# puts "#{person.fullname} drew #{giftees[i].fullname}"
	end
end

def check_santas(people)
	valid = true
	people.each do |person|
		valid = valid & person.valid_santa?
	end
	valid
end

puts "\n\nWelcome to Secret Santa!  Please input names in the following format:"
puts "FIRST_NAME space FAMILY_NAME space <EMAIL_ADDRESS>, pressing return after each."
puts "Type q and hit enter to quit."

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

iter = 0
begin
	assign_santas(people)
	iter +=1
end until check_santas(people)

puts "\n\n\nWoo hoo!  Santas have been assigned.  It took #{iter} iterations to find a winning combination."
puts "\n\n\nEmailing entrants..."

people.each do |person|
	send_email person.email, :santa => person.giftee.fullname, :recipient => person.firstname
end

puts "\n\n\nEmailing complete.  Happy gifting!\n\n\n"

