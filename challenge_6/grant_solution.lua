-- to run: lua grant_solution.lua
local start_clock_time = os.clock()
local dict_contents = io.open("/usr/share/dict/words"):read("*all")
local input_contents = io.open("programming_challenge_6_source.txt"):read("*all")

-- build LUT:
local words = {}
for word in dict_contents:gmatch("%a+") do words[word] = true end

-- enumerate all words in input content:
local total_dict_words = 0
for w in input_contents:gmatch("%a+") do
	if words[w:lower()] == true then
		total_dict_words = total_dict_words + 1
	end
end

local time_in_secs = os.clock() - start_clock_time
print("Words: "..total_dict_words.." Time: "..time_in_secs)

