require 'pp'

seed = [ 
	[5,   4,  2],
	[10,  1,  1],
	[11, 23, 25]
]

# Helper for printing matrix
def print_matrix(matrix, vert_width = 9)
	matrix.each do |row|
		row_str = ""
		row.each do |value|
			val_str = value.to_s
			row_str += " "*(vert_width - val_str.length) + val_str
		end
		pp row_str
	end
end


class Padder
	def self.pad_zeros(matrix, iterations = 1)
		iterations.times do
			pad_left_with_zeros(matrix)
			pad_right_with_zeros(matrix)
			pad_top_with_zeros(matrix)
			pad_bottom_with_zeros(matrix)
		end

		return matrix
	end

	private
	def self.pad_left_with_zeros(matrix)
		matrix.map{|row| row.unshift(0)}
	end

	def self.pad_right_with_zeros(matrix)
		matrix.map{|row| row << 0}
	end

	def self.pad_top_with_zeros(matrix)
		matrix.unshift(zeros_row(matrix.first.length))
	end

	def self.pad_bottom_with_zeros(matrix)
		matrix << zeros_row(matrix.first.length)
	end

	def self.zeros_row(length)
		Array.new(length, 0)
	end
end

class Filters
	def self.sum(matrix, row, col)
		sum = 0
		horiz = [row-1, row, row+1]
		vert = [col-1, col, col+1]

		vert.each do |v_index|
			horiz.each do |c_index|
				sum += matrix[v_index][c_index]
			end
		end
		return sum
	end
end

class Traverse
	attr_reader :matrix
	def initialize(matrix:)
		@matrix = matrix
	end

	def traverse
		up
		right
		down
		left
		Padder.pad_zeros(@matrix)
	end

	private

	def up
	 	v_entry = @matrix.length - 3
		col = @matrix.first.length - 2

		(v_entry).downto(1).each do |v_i|
			@matrix[v_i][col] += Filters.sum(@matrix, col, v_i)
		end
	end

	def right
	 	row = 1
		col_entry = @matrix.first.length - 3

		(col_entry).downto(1).each do |c_i|
			@matrix[row][c_i] += Filters.sum(@matrix, c_i, row)
		end
	end

	def down
	 	v_range = Range.new(2, @matrix.length - 2).to_a
		col = 1

		v_range.each do |v_i|
			@matrix[v_i][col] += Filters.sum(@matrix, col, v_i)
		end
	end

	def left
	 	row = @matrix.length - 2
	 	c_range = Range.new(2, @matrix.first.length - 2).to_a

		c_range.each do |c_i|
			@matrix[row][c_i] += Filters.sum(@matrix, c_i, row)
		end
	end
end

trav = Traverse.new(matrix: Padder.pad_zeros(seed, 2))
3.times do
	trav.traverse
end

print_matrix(trav.matrix)