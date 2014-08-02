# This week's quiz is to build a library that adds a class method called build() to Regexp. 
# build() should accept a variable number of arguments which can include integers and ranges 
# of integers. Have build() return a Regexp object that will match only integers in the set 
# of passed arguments.

def Regexp.build( *args )
	args.map!{ |x| Array(x) }.flatten!
	regex = ""
	args.each do |arg|
		regex.concat("^")
		regex.concat("[-]") if arg < 0
		regex.concat("(#{arg.abs}$)|")
	end
	regex.chop!
	Regexp.new regex
end

lucky = Regexp.build( 3, 7 )
puts "lucky: #{lucky}"
puts "Result of 7: #{!("7" =~ lucky).nil?}"
puts "Result of 13: #{!("13" =~ lucky).nil?}"
puts "Result of 3: #{!("3" =~ lucky).nil?}"

month = Regexp.build( 1..12 )
puts "month: #{month}"
puts "Result of 0: #{!("0" =~ month).nil?}"
puts "Result of 1: #{!("1" =~ month).nil?}"
puts "Result of 5: #{!("5" =~ month).nil?}"
puts "Result of 12: #{!("12" =~ month).nil?}"

day = Regexp.build( 1..31 )
puts "day: #{day}"
puts "Result of 6: #{!("6" =~ day).nil?}"
puts "Result of 16: #{!("16" =~ day).nil?}"
puts "Result of Tues: #{!("Tues" =~ day).nil?}"

year = Regexp.build( 98, 99, 2000..2005 )
puts "year: #{year}"
puts "Result of 04: #{!("04" =~ year).nil?}"
puts "Result of 2004: #{!("2004" =~ year).nil?}"
puts "Result of 99: #{!("99" =~ year).nil?}"

negs = Regexp.build( -10..-1)
puts "negs: #{negs}"
puts "Result of -20: #{!("-20" =~ negs).nil?}"
puts "Result of -5: #{!("-5" =~ negs).nil?}"
puts "Result of 5: #{!("5" =~ negs).nil?}"

# num = Regexp.build( 0..1_000_000 )
# puts "num: #{num}"
# puts "Result of -1: #{!("-1" =~ num).nil?}"
# puts "Result of 1000: #{!("1000" =~ num).nil?}"