#!/usr/bin/env ruby

start_word = ARGV[0]
end_word = ARGV[1]
ALPHA = 'a'..'z'

if start_word == end_word
  puts start_word
  puts end_word
  exit
end

if start_word.nil? or end_word.nil?
  puts "Needs a starting and ending word to make the chain"
  exit
end

if start_word.length != end_word.length
  puts "Word lengths do not match."
  exit
end

class Chain
  def initialize
	@dictionary = Hash.new { |hash, key| hash[key] = [] }
  end

  def gen_matches()
	@dictionary.keys.each do |word|
	  w = word.to_s
	  mutant = w.dup
	  w.length.times do |n|
		ALPHA.each do |c|
		  mutant[n] = c
		  ms = mutant.to_sym
		  if @dictionary.has_key? ms
			@dictionary[word].push(ms)
		  end
		end
		mutant[n] = w[n]
	  end
	end
	self
  end

  def load_dict(len)
	IO.foreach("/usr/share/dict/words") do |word|
	  word = word.downcase.chomp!
	  if word.length == len
		@dictionary[word.to_sym]
	  end
	end
	self
  end

  def search(start_word, end_word)
	sw_s = start_word.to_sym
	x = end_word.to_sym
	queue = [sw_s]
	parents = { sw_s => nil }
	catch(:done) do
	  until queue.empty?
		curr = queue.shift
		@dictionary[curr].each do |word|
		  unless parents.key? word
		  	parents[word] = curr
			if word == x
			  throw(:done)
			end
			queue << word
		  end
		end
	  end
	  return false #nothing found
	end
	traverse(x, parents)
  end

  def traverse(x, tree)
	path = [x]
	until tree[x].nil?
	  x = tree[x]
	  path.unshift(x)
	end
	path.each do |word|
	  puts word.to_s
	end
	true
  end

end

c = Chain.new
unless c.load_dict(start_word.length).gen_matches().search(start_word, end_word)
  puts "No chain found."
end
