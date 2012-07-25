#Print a banner, like an idiot
def print_banner()
	print "\e[5;1;32;44m"
	print "@====@                        @====@\n"
	print " |  | Programming Challenge #1 |  |\n"
	print " |  |  Roman Numeral Converter |  |\n"
	print "@====@                        @====@\n"
	print "LOOK AT THIS!!! I PROBABLY LOST!!!"
	print "\e[0m\n"
end

print_banner()

#Define all valid roman numerals
romanSymbols = {
	'I'=>1,
	'V'=>5,
	'X'=>10,
	'L'=>50,
	'C'=>100,
	'D'=>500,
	'M'=>1000
}

#Loop through each line of the input file
ARGF.each_line do |line|
	#Fetch input value by stripping newline
	inputValue = line.strip.upcase

	#Initialize converted value
	convertedValue = 0

	#Start loop at last character
	i = inputValue.length-1

	#Loop through all characters of the string in reverse
	while i > -1
		#Grab current character
		currentCharacter = inputValue[i,1]

		#Break from loop if character is an invalid roman numeral
		#Using 'unless' because it's perl/ruby-ish and I'm a jerk
		unless romanSymbols.has_key? currentCharacter
			#Deem an invalid roman numeral and break from loop
			convertedValue = "Invalid Roman Numeral"
			break
		end

		#Grab next character
		nextCharacter = inputValue[i-1,1]

		#Determine if the difference of two numerals must be found (e.g. IV)
		if i!=0 and romanSymbols.has_key? nextCharacter and romanSymbols[nextCharacter] < romanSymbols[currentCharacter]
			#Add difference to convertedValue sum
			convertedValue +=  romanSymbols[currentCharacter] - romanSymbols[nextCharacter]
			#Skip a character, as it was used to find the difference
			i-=2
		else
			#Add to convertedValue sum
			convertedValue += romanSymbols[currentCharacter]
			i-=1 
		end
	end

	#Print result
    print "#{line.strip} --> #{convertedValue}\n"
end

print_banner()