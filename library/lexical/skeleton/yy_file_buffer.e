indexing

	description:

		"Lexical analyzer input file buffers";

	library:    "Gobo Eiffel Lexical Library";
	author:     "Eric Bezault <ericb@gobo.demon.co.uk>";
	copyright:  "Copyright (c) 1997, Eric Bezault";
	date:       "$Date$";
	revision:   "$Revision$"

class YY_FILE_BUFFER

inherit

	YY_BUFFER
		rename
			make as make_from_string
		export
			{NONE} make_from_string, make_from_buffer
		redefine
			fill, filled, flush
		end

	KL_FILE_ROUTINES
		export
			{NONE} all
		end

	KL_STRING_ROUTINES
		export
			{NONE} all
		end

creation

	make, make_with_size

feature -- Initialization

	make (a_file: like FILE_type) is
			-- Create a new buffer for `a_file'.
		require
			a_file_not_void: a_file /= Void
			a_file_open_read: a_file.is_open_read
		do
			make_with_size (a_file, Default_capacity)
		ensure
			count_set: count = 0
			file_set: file = a_file
			beginning_of_line: beginning_of_line
		end
		
	make_with_size (a_file: like FILE_type; size: INTEGER) is
			-- Create a new buffer of capacity `size' for `a_file'.
		require
			a_file_not_void: a_file /= Void
			a_file_open_read: a_file.is_open_read
			size_positive: size >= 0
		do
			capacity := size
				-- `content' has to be 2 characters longer
				-- than the size given because we need to
				-- put in 2 end-of-buffer characters.
			content := string__make_buffer (size + 2)
			set_file (a_file)
		ensure
			capacity_set: capacity = size
			count_set: count = 0
			file_set: file = a_file
			beginning_of_line: beginning_of_line
		end

feature -- Access

	file: like FILE_type
			-- Input file

feature -- Setting

	set_file (a_file: like FILE_type) is
			-- Set `file' to `a_file'.
		require
			a_file_not_void: a_file /= Void
			a_file_open_read: a_file.is_open_read
		do
			flush
			file := a_file
		ensure
			count_set: count = 0
			file_set: file = a_file
			beginning_of_line: beginning_of_line
		end

feature -- Status report

	filled: BOOLEAN
			-- Did the last call to `fill' add more
			-- characters to buffer? 

	interactive: BOOLEAN
			-- Is the input source interactive?
			-- If so, we will have to read characters one by one.

feature -- Status setting

	set_interactive (b: BOOLEAN) is
			-- Set `interactive' to `b'.
		do
			interactive := b
		ensure
			interactive_set: interactive = b
		end

feature -- Element change

	fill is
			-- Fill buffer with characters from `file'.
			-- Do not lose unprocessed characters in buffer.
			-- Resize buffer if necessary. Set `filled' to True
			-- if characters have been added to buffer.
		local
			i, j, nb: INTEGER
			buff, str: STRING
			char: CHARACTER
		do
				-- If the last call to `fill' failed to add
				-- more characters, this means that the end of
				-- file has already been reached. Do not attempt
				-- to fill again the buffer in that case.
			if filled then
				buff := content
					-- First move last characters to start of buffer.
					--| This should be done with a block copy.
				nb := count
				from i := position until i > nb loop
					j := j + 1
					buff.put (buff.item (i), j)
					i := i + 1
				end
				count := j
				position := 1
				nb := capacity - count
				if nb = 0 then
						-- Buffer is full. Resize it.
					capacity := capacity * 2
					if capacity = 0 then
						capacity := Default_capacity
					end
						-- Make sure `buffer.count' is big enough.
						-- Include room for 2 EOB characters.
					if capacity + 2 - buff.count > 0 then
							-- Set `content.count' to `capacity' + 2.
						string__resize_buffer (buff, capacity + 2)
					end
					nb := capacity - count
				end
					-- Read in more data.
				if interactive then
						-- Read characters one by one.
					file.read_character
					char := file.last_character
					if file__end_of_file (file) then
						j := j + 1
						buff.put (char, j)
						filled := True
					else
						filled := False
					end
				elseif not file__end_of_file (file) then
					if nb > Read_buffer_capacity then
						nb := Read_buffer_capacity
					end
#ifdef VE
					from
						file.read_character
						i := 1
					until
						file__end_of_file (file) or
						i > nb
					loop
						j := j + 1
						buff.put (file.last_character, j)
						file.read_character
						i := i + 1
					end
					if i > 1 then
						filled := True
					else
						filled := False
					end
#else
					file.read_stream (nb)
					str := file.last_string
					nb := str.count
					if nb > 0 then
						from i := 1 until i > nb loop
							j := j + 1
							buff.put (str.item (i), j)
							i := i + 1
						end
						filled := True
					else
						filled := False
					end
#endif
				else
					filled := False
				end
				count := j
				buff.put (End_of_buffer_character, j + 1)
				buff.put (End_of_buffer_character, j + 2)
			end
		end

	flush is
			-- Flush buffer.
		do
			count := 0
				-- We always need two end-of-file characters.
				-- The first causes a transition to the end-of-buffer
				-- state. The second causes a jam in that state.
			content.put (End_of_buffer_character, 1)
			content.put (End_of_buffer_character, 2)
			position := 1
			beginning_of_line := True
			filled := True
		end

feature {NONE} -- Constants

	Read_buffer_capacity: INTEGER is 8192
			-- Maximum number of characters to 
			-- be read at a time

invariant

	file_not_void: file /= Void
	file_open_read: file.is_open_read

end -- class YY_FILE_BUFFER
