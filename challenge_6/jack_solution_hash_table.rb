## Requires: jruby.
## Run using: jruby jack_solution_hash_table.rb 130000
## 2.225 seconds

require 'set'

def process_words(words, dictionary)
  puts "Starting thread #{Thread.current.object_id}\n"

  found = 0
  words.each do |word|
    if dictionary.include? word
      found += 1
    end
  end

  puts "Done with thread #{Thread.current.object_id}\n"
  Thread.current[:found] = found
end

started = Time.now

dictionary_path = '/usr/share/dict/words'
word_list = 'programming_challenge_6_source.txt'

# Read the dictionary into an array.
dictionary = Set.new
File.open(dictionary_path, 'r').each_line do |word|
  word = word.gsub("\n",'')
  dictionary.add word
end

# Read the list of words into an array.
all_words = []
File.open(word_list, 'r').each_line do |line|
  line_words = line.split
  line_words.each { |word| all_words << word }
end

# Get the chunk size, and then spawn enough threads to accomodate the
# number of chunks.
chunk_size = (ARGV[0].nil?) ? 2000 : ARGV[0].to_i
threads = []
all_words.each_slice(chunk_size) do |slice|
  threads << Thread.new { process_words(slice, dictionary) }
end

# Use Thread.join to make sure that child threads aren't killed when the
# main thread exits.
found_words_count = 0
threads.each do |t|
  t.join
  found_words_count += t[:found]
end
ended = Time.now
total_time = (ended - started)

puts "Threads: #{threads.count}"
puts "Words: #{found_words_count}"
puts "Time: #{total_time}"