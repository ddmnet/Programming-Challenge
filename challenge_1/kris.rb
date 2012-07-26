#!/usr/bin/env ruby

STDIN.read.split("\n").each do |string|
	valid = true
	container = Array.new
	string.each_char do | a|
		# if a == "M"
		# 	container << 1000	
		# end
		#I = 1, V = 5, X = 10, L = 50, C = 100, D = 500, M = 1000
		case a
		when "M"
			container << 1000
		when "D"
			container << 500
		when "C"
			container << 100
		when "L"
			container << 50
		when "X"
			container << 10
		when "V"
			container << 5
		when "I"
			container << 1
		else
			container << 0
		end
   	end

   	base = 0
   	container.each_with_index do |x, i|
   		y = container[i-1]
   		if x == 0
   			valid = false
   		end
   		if i == 0
   			base = base + x
   			# puts x + base
   		else
   			if i == 1
   				if x < y
   					
   				end
   			end
   			if y < x
   				base = base +( x - y * 2)
   				
   			else
   				base = base + x	
   			end
   		end
   	end
   	
   	if valid == false
   		puts "Invalid"
   		valid == true
   	else
   		puts base 
   		base = 0
   	end

end