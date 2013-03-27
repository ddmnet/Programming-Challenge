## Requires: jruby.
## Run using: jruby jack_solution_hash_table.rb 130000
## 1.58 seconds

require 'set'

def process_words(words, dictionary)
  found = 0
  words.each do |word|
    if dictionary.include? word
      found += 1
    end
  end

  Thread.current[:found] = found
end

started = Time.now

dictionary_path = '/usr/share/dict/words'
word_list = 'programming_challenge_6_source.txt'
line_split_regex = Regexp.new(/\r\n?/)

file_threads = []

# Read the dictionary into the set.
file_threads << Thread.new {
  dictionary = Set.new
  newline_regex = Regexp.new("\n")
  text = File.open(dictionary_path, 'r').read
  text.gsub!(line_split_regex, "\n")
  text.each_line do |line|
    dictionary.add line.gsub!(newline_regex, '')
  end
  Thread.current[:dictionary] = dictionary
}

# Read the list of words into an array.
file_threads << Thread.new {
  all_words = []
  text = File.open(word_list, 'r').read
  text.gsub!(line_split_regex, "\n")
  text.each_line do |line|
    all_words.concat line.split
  end
  Thread.current[:all_words] = all_words
}

# Collect all_words array and dictionary set.
all_words = nil
dictionary = nil
file_threads.each do |t|
  t.join
  if !t[:all_words].nil?
    all_words = t[:all_words]
  end
  if !t[:dictionary].nil?
    dictionary = t[:dictionary]
  end
end

# # Get the chunk size, and then spawn enough threads to accomodate the
# # number of chunks.
chunk_size = (ARGV[0].nil?) ? 130000 : ARGV[0].to_i
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

puts "Words: #{found_words_count}"
puts "Time: #{total_time}"