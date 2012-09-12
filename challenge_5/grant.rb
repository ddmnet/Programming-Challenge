
# double halve (Odd numbers cannot be halved.) add_two

def distance(a,b)
	return (a-b).abs
end

class Solver
	def initialize
		@op_queue = []
	end
	def next_op
		if @current_val > @end_val then
			if @current_val.modulo(2) == 1 then
				@op_queue.push "double"
				@op_queue.push "add_two"
				@op_queue.push "halve"

				return
			end
			@op_queue.push "halve"
		else	# current val is < @end_val
			if @current_val*2 < @end_val then
				@op_queue.push "double"
			else
				@op_queue.push "add_two"
			end

		end
	end

	def step
		if @op_queue.length <= 0 then
			self.next_op
		end

		op = @op_queue[0]
		@op_queue.slice!(0)

		test_val = @current_val
		if op == "halve" then test_val = @current_val / 2 end
		if op == "double" then test_val = @current_val * 2 end
		if op == "add_two" then test_val = @current_val + 2 end

		if @stack.include?(test_val) and @op_queue.length == 0 then
			# we've been here before and there's nothing left to do!
			@op_queue.push "double"
			@op_queue.push "add_two"
			@op_queue.push "halve"
		end
		
		@stack.push test_val
		@current_val = test_val
	end

	def solve(start_val, end_val)
		@stack = []
		@current_val = start_val
		@end_val = end_val
		puts start_val
		while @current_val != @end_val do
			self.step
			puts @current_val
		end
	end
end

s = Solver.new()
s.solve(ARGV[0].to_i, ARGV[1].to_i)


