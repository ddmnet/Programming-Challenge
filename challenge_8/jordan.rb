# jordan carney
# programming challenge #8
# run: time ruby jordan.rb

class MaxSumSolver
	def initialize(filename)
		@filename = filename
	end

	def max_sum
		rows = process_input

		# the process:
		# 1. starts at the base row of the triangle
		# 2. finds the max node value of adjacent column nodes
		# 3. sums that with the corresponding diagonal node with adjancency to both "maxed" nodes
		# this sequence will iterate up the triangle and the max sum will be the tip node

		(rows.size - 2).downto(0) do |row|
			0.upto(rows[row].size - 1) do |col|
				rows[row][col] += [rows[row+1][col], rows[row+1][col+1]].max
			end
		end

		return rows[0][0]
	end

	private
		def process_input
			rows = Array.new
			File.open(@filename).readlines.each_with_index do |row, index|
				rows[index] = row.split.map(&:to_i)
			end
			return rows
		end
end

solution = MaxSumSolver.new("triangle.txt")
puts solution.max_sum