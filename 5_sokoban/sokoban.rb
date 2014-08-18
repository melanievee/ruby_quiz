class Sokoban

	def initialize
		@level = get_level
		@level_map = load_level
		play
	end

	def load_level
		puts "Loading Sokoban level #{@level}."
		lines = File.readlines('sokoban_levels.txt')
		maxlength = 0
		lines.each do |line|
			maxlength = [line.length, maxlength].max 
		end
    lines = lines.map {|line| line.chomp.ljust(maxlength-1)}.join("\n")
    levels = lines.split(/\n {#{maxlength-1}}\n/)
    levels[@level-1].split("\n")
	end

	def print_level
		puts @level_map
	end

	def get_level
		puts "Type desired level (1-50) and press enter."
		level = gets.chomp.to_i
		if level > 0 && level <= 50
			return level
		else
			puts "Please input a valid level."
			get_level
		end
	end

	def get_move
		puts "Input player move using arrow keys.  Type r to reset or q to quit, then hit <enter>."
		input = gets.chomp
		if input == "\e[A" 
			return :up
		elsif input == "\e[B" 
			return :down
		elsif input == "\e[C"
			return :right 
		elsif input == "\e[D"
			return :left
		elsif input == "q"
			return :quit
		elsif input == "r"
			return :reset
		else
			puts "Invalid input."
			get_move
		end
	end

	def move_player(move)
		player_row, player_col = find_player
		delta_row, delta_col = define_deltas(move)
		p_dest_icon = find_icon(player_row+delta_row,player_col+delta_col)
		p_icon = find_icon(player_row, player_col)

		if p_dest_icon == "#"
			puts "Move not possible"
		elsif p_dest_icon =~ /\*|o/ # Crate in front of player
			c_dest_icon = find_icon(player_row+2*delta_row, player_col+2*delta_col)
			c_icon = p_dest_icon
			if c_dest_icon =~ /o|#|\*/
				puts "Move not possible."
			else
				set_crate_dest(c_dest_icon, player_row+2*delta_row, player_col+2*delta_col)
				set_player_dest(c_icon, player_row+delta_row, player_col+delta_col)
				set_player_trail(p_icon, player_row, player_col)
			end
		else
			set_player_dest(p_dest_icon, player_row+delta_row, player_col+delta_col)
			set_player_trail(p_icon, player_row, player_col)
		end
	end

	def set_crate_dest(dest_icon, new_row, new_col)
		if dest_icon == "."
			set_icon(new_row, new_col, "*")
		else
			set_icon(new_row, new_col, "o")
		end
	end

	def set_player_dest(dest_icon, new_row, new_col)
		if dest_icon =~ /\.|\*/
			set_icon(new_row, new_col, "+")
		else
			set_icon(new_row, new_col, "@")
		end
	end

	def set_player_trail(player_icon, player_row, player_col)
		if player_icon == "+"
			set_icon(player_row, player_col, ".")
		else	
			set_icon(player_row, player_col, " ")
		end
	end

	def find_icon(row, col)
		@level_map[row][col]
	end

	def set_icon(row, col, icon_string)
		@level_map[row][col] = icon_string
	end

	def define_deltas(move)
		delta_row = 0 #delta row
		delta_col = 0 #delta column
		case move
		when :up
			delta_row = -1
		when :down
			delta_row = 1
		when :left
			delta_col = -1
		when :right
			delta_col = 1
		end
		return delta_row, delta_col
	end

	def find_player
		@level_map.each_with_index do |content, rownum|
			unless content.index(/@|\+/).nil?
				return rownum, content.index(/@|\+/)
			end
		end
	end

	def won_game?
		@level_map.each do |row|
			if row.include?("o")
				return false
			end
		end
		puts "\n\nWOO HOO YOU WON!"
		return true
	end

	def play
		print_level
		move = get_move
		while move != :quit
			if move == :reset
				@level_map = load_level
			else
				move_player(move)
			end
			print_level
			break if won_game?
			move = get_move
		end
		puts "Thanks for playing Sokoban!\n\n"
	end
end

game = Sokoban.new