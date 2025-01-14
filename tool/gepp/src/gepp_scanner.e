note

	description:

		"Scanners for 'gepp' preprocessors"

	copyright: "Copyright (c) 1999-2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"

deferred class GEPP_SCANNER

inherit

	YY_COMPRESSED_SCANNER_SKELETON
		rename
			make as make_compressed_scanner_skeleton,
			reset as reset_compressed_scanner_skeleton
		redefine
			wrap, output
		end

	GEPP_TOKENS
		export
			{NONE} all
		end


feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= S_SKIP_EOL)
		end

feature {NONE} -- Implementation

	yy_build_tables
			-- Build scanner tables.
		do
			yy_nxt := yy_nxt_template
			yy_chk := yy_chk_template
			yy_base := yy_base_template
			yy_def := yy_def_template
			yy_ec := yy_ec_template
			yy_meta := yy_meta_template
			yy_accept := yy_accept_template
		end

	yy_execute_action (yy_act: INTEGER)
			-- Execute semantic action.
		do
			inspect yy_act
when 1 then
--|#line 41 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 41")
end

						-- Comment.
						set_start_condition (S_SKIP_EOL)
						if empty_lines then
							output_file.put_new_line
						end
					
when 2 then
--|#line 48 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 48")
end

						last_token := P_IFDEF
						set_start_condition (S_PREPROC)
						if empty_lines then
							output_file.put_new_line
						end
					
when 3 then
--|#line 55 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 55")
end

						last_token := P_IFNDEF
						set_start_condition (S_PREPROC)
						if empty_lines then
							output_file.put_new_line
						end
					
when 4 then
--|#line 62 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 62")
end

						last_token := P_ELSE
						set_start_condition (S_PREPROC)
						if empty_lines then
							output_file.put_new_line
						end
					
when 5 then
--|#line 69 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 69")
end

						last_token := P_ENDIF
						set_start_condition (S_PREPROC)
						if empty_lines then
							output_file.put_new_line
						end
					
when 6 then
--|#line 76 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 76")
end

						last_token := P_INCLUDE
						set_start_condition (S_PREPROC)
						if empty_lines then
							output_file.put_new_line
						end
					
when 7 then
--|#line 83 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 83")
end

						last_token := P_DEFINE
						set_start_condition (S_PREPROC)
						if empty_lines then
							output_file.put_new_line
						end
					
when 8 then
--|#line 90 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 90")
end

						last_token := P_UNDEF
						set_start_condition (S_PREPROC)
						if empty_lines then
							output_file.put_new_line
						end
					
when 9 then
--|#line 97 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 97")
end

						echo
						set_start_condition (S_READLINE)
					
when 10, 11 then
--|#line 101 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 101")
end

						echo
						line_nb := line_nb + 1
					
when 12 then
--|#line 106 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 106")
end

						echo
					
when 13 then
--|#line 112 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 112")
end

						echo
						line_nb := line_nb + 1
						set_start_condition (INITIAL)
					
when 14 then
--|#line 117 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 117")
end

						echo
						set_start_condition (INITIAL)
					
when 15 then
--|#line 124 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 124")
end

						line_nb := line_nb + 1
						set_start_condition (INITIAL)
					
when 16 then
--|#line 128 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 128")
end

						set_start_condition (INITIAL)
					
when 17 then
--|#line 134 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 134")
end
-- Separator.
when 18 then
--|#line 135 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 135")
end

						last_token := P_STRING
						last_string_value := text_substring (2, text_count - 1)
					
when 19 then
--|#line 139 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 139")
end

						last_token := P_NAME
						last_string_value := text
					
when 20 then
--|#line 143 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 143")
end
last_token := P_AND
when 21 then
--|#line 144 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 144")
end
last_token := P_OR
when 22 then
--|#line 145 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 145")
end

						last_token := P_EOL
						line_nb := line_nb + 1
						set_start_condition (INITIAL)
					
when 23 then
--|#line 154 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 154")
end
last_token := text_item (1).code
when 24 then
--|#line 157 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 157")
end
last_token := text_item (1).code
when 25 then
--|#line 0 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 0")
end
last_token := yyError_token
fatal_error ("scanner jammed")
			else
				last_token := yyError_token
				fatal_error ("fatal scanner internal error: no action found")
			end
			yy_set_beginning_of_line
		end

	yy_execute_eof_action (yy_sc: INTEGER)
			-- Execute EOF semantic action.
		do
			inspect yy_sc
when 1 then
--|#line 150 "gepp_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'gepp_scanner.l' at line 150")
end

						last_token := P_EOL
						set_start_condition (INITIAL)
					
			else
				terminate
			end
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER]
			-- Template for `yy_nxt'
		once
			Result := yy_fixed_array (<<
			    0,   33,   72,   12,   33,   13,   14,   15,   16,   17,
			   14,   18,   19,   19,   19,   19,   19,   19,   19,   19,
			   19,   19,   20,   27,   42,   43,   44,   28,   29,   45,
			   30,   51,   35,   71,   31,   70,   52,   10,   10,   10,
			   10,   11,   11,   11,   11,   21,   21,   21,   21,   23,
			   23,   23,   23,   25,   25,   25,   25,   37,   37,   37,
			   37,   39,   39,   39,   39,   27,   69,   27,   27,   68,
			   67,   66,   65,   64,   63,   62,   61,   60,   59,   58,
			   57,   56,   55,   54,   53,   50,   49,   48,   40,   38,
			   47,   32,   46,   41,   26,   40,   38,   36,   34,   32,

			   26,   72,   24,   24,   22,   22,    9,   72,   72,   72,
			   72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
			   72,   72,   72,   72, yy_Dummy>>)
		end

	yy_chk_template: SPECIAL [INTEGER]
			-- Template for `yy_chk'
		once
			Result := yy_fixed_array (<<
			    0,   78,    0,    2,   78,    2,    3,    3,    3,    3,
			    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
			    3,    3,    3,   13,   29,   29,   30,   13,   13,   30,
			   13,   44,   79,   70,   13,   66,   44,   73,   73,   73,
			   73,   74,   74,   74,   74,   75,   75,   75,   75,   76,
			   76,   76,   76,   77,   77,   77,   77,   80,   80,   80,
			   80,   81,   81,   81,   81,   82,   65,   82,   82,   62,
			   61,   60,   59,   58,   57,   55,   54,   53,   52,   51,
			   50,   49,   48,   46,   45,   43,   42,   41,   39,   37,
			   33,   32,   31,   28,   25,   23,   21,   20,   18,   15,

			   11,    9,    8,    7,    6,    5,   72,   72,   72,   72,
			   72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
			   72,   72,   72,   72, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER]
			-- Template for `yy_base'
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    5,    0,  102,  101,  100,   99,  101,
			  106,   97,  106,   18,  106,   97,  106,    0,   92,    0,
			   80,   93,  106,   92,  106,   91,  106,    0,   83,   11,
			   15,   78,   89,   86,  106,    0,  106,   86,  106,   85,
			  106,   76,   71,   76,   22,   76,   74,  106,   70,   71,
			   68,   69,   69,   64,   66,   61,  106,   63,   62,   62,
			   55,   59,   59,  106,  106,   55,   26,  106,  106,  106,
			   23,  106,  106,   36,   40,   44,   48,   52,    0,   28,
			   56,   60,   64, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER]
			-- Template for `yy_def'
		once
			Result := yy_fixed_array (<<
			    0,   73,   74,   72,    3,   75,   75,   76,   76,   72,
			   72,   77,   72,   72,   72,   72,   72,   78,   72,   79,
			   72,   80,   72,   81,   72,   77,   72,   82,   72,   72,
			   72,   72,   72,   78,   72,   79,   72,   80,   72,   81,
			   72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
			   72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
			   72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
			   72,   72,    0,   72,   72,   72,   72,   72,   72,   72,
			   72,   72,   72, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER]
			-- Template for `yy_ec'
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make_filled (0, 0, 256)
			yy_ec_template_1 (an_array)
			yy_ec_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_ec_template_1 (an_array: ARRAY [INTEGER])
			-- Fill chunk #1 of template for `yy_ec'.
		do
			yy_array_subcopy (an_array, <<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    2,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    2,    1,    4,    5,    1,    1,    6,    1,
			    1,    1,    1,    1,    1,    7,    7,    1,    7,    7,
			    7,    7,    7,    7,    7,    7,    7,    7,    1,    1,
			    1,    1,    1,    1,    1,    7,    7,    8,    9,   10,
			   11,    7,    7,   12,    7,    7,   13,    7,   14,    7,
			    7,    7,    7,   15,    7,   16,    7,    7,    7,    7,
			    7,    1,    1,    1,    1,    7,    1,    7,    7,    8,

			    9,   10,   11,    7,    7,   12,    7,    7,   13,    7,
			   14,    7,    7,    7,    7,   15,    7,   16,    7,    7,
			    7,    7,    7,    1,   17,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>,
			1, 200, 0)
		end

	yy_ec_template_2 (an_array: ARRAY [INTEGER])
			-- Fill chunk #2 of template for `yy_ec'.
		do
			yy_array_subcopy (an_array, <<
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>,
			1, 57, 200)
		end

	yy_meta_template: SPECIAL [INTEGER]
			-- Template for `yy_meta'
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    2,    3,    1,    1,    4,    4,    4,
			    4,    4,    4,    4,    4,    4,    4,    1, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER]
			-- Template for `yy_accept'
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,   14,   14,   16,   16,   26,
			   24,   12,   11,    9,   23,   17,   22,   23,   23,   19,
			   23,   14,   13,   16,   15,   12,   10,    1,    0,    0,
			    0,    0,   17,    0,   20,   19,   21,   14,   13,   16,
			   15,    0,    0,    0,    0,    0,    0,   18,    0,    0,
			    0,    0,    0,    0,    0,    0,    4,    0,    0,    0,
			    0,    0,    0,    5,    2,    0,    0,    8,    7,    3,
			    0,    6,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER = 106
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER = 72
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER = 73
			-- Mark between normal states and templates

	yyNull_equiv_class: INTEGER = 1
			-- Equivalence code for NULL character

	yyReject_used: BOOLEAN = false
			-- Is `reject' called?

	yyVariable_trail_context: BOOLEAN = false
			-- Is there a regular expression with
			-- both leading and trailing parts having
			-- variable length?

	yyReject_or_variable_trail_context: BOOLEAN = false
			-- Is `reject' called or is there a
			-- regular expression with both leading
			-- and trailing parts having variable length?

	yyNb_rules: INTEGER = 25
			-- Number of rules

	yyEnd_of_buffer: INTEGER = 26
			-- End of buffer rule code

	yyLine_used: BOOLEAN = false
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN = false
			-- Is `position' used?

	INITIAL: INTEGER = 0
	S_PREPROC: INTEGER = 1
	S_READLINE: INTEGER = 2
	S_SKIP_EOL: INTEGER = 3
			-- Start condition codes

feature -- User-defined features



feature {NONE} -- Initialization

	make
			-- Create a new scanner.
		do
			make_with_buffer (Empty_buffer)
			output_file := std.output
			line_nb := 1
		end

feature -- Initialization

	reset
			-- Reset scanner before scanning next input.
		do
			reset_compressed_scanner_skeleton
			line_nb := 1
		end

feature -- Access

	line_nb: INTEGER
			-- Current line number

	include_stack: DS_STACK [YY_BUFFER]
			-- Input buffers not completely parsed yet
		deferred
		ensure
			include_stack_not_void: Result /= Void
			no_void_buffer: not Result.has_void
		end

	line_nb_stack: DS_STACK [INTEGER]
			-- Line numbers in the corresponding input buffers in `include_stack'
		deferred
		ensure
			line_nb_stack_not_void: Result /= Void
			same_count: Result.count = include_stack.count
		end

feature -- Status report

	ignored: BOOLEAN
			-- Is current line ignored?
		deferred
		end

	empty_lines: BOOLEAN
			-- Should empty lines be generated when lines are
			-- ignored in order to preserve line numbering?

feature -- Status setting

	set_empty_lines (b: BOOLEAN)
			-- Set `empty_lines' to `b'.
		do
			empty_lines := b
		ensure
			empty_lines_set: empty_lines = b
		end

feature -- Element change

	wrap: BOOLEAN
			-- Should current scanner terminate when end of file is reached?
			-- True unless an include file was being processed.
		local
			l_old_buffer: YY_BUFFER
			a_file: KI_CHARACTER_INPUT_STREAM
		do
			if not include_stack.is_empty then
				l_old_buffer := input_buffer
				set_input_buffer (include_stack.item)
				line_nb := line_nb_stack.item
				line_nb_stack.remove
				include_stack.remove
				if attached {YY_FILE_BUFFER} l_old_buffer as l_file_buffer then
					a_file := l_file_buffer.file
					if a_file.is_closable then
						a_file.close
					end
				end
				set_start_condition (INITIAL)
			else
				Result := True
			end
		end

feature -- Output

	output_file: KI_TEXT_OUTPUT_STREAM
			-- Output file

	set_output_file (a_file: like output_file)
			-- Set `output_file' to `a_file'.
		require
			a_file_not_void: a_file /= Void
			a_file_open_write: a_file.is_open_write
		do
			output_file := a_file
		ensure
			output_file_set: output_file = a_file
		end

	output (a_text: like text)
			-- Output `a_text' to `output_file'.
		local
			nb: INTEGER
		do
			if not ignored then
				nb := a_text.count
				if nb > 0 then
					if a_text.item (nb) = '%N' then
						nb := nb - 1
						if nb > 0 and then a_text.item (nb) = '%R' then
							nb := nb - 1
						end
						if nb > 0 then
							output_file.put_line (a_text.substring (1, nb))
						else
							output_file.put_new_line
						end
					else
						output_file.put_string (a_text)
					end
				end
			elseif empty_lines then
				output_file.put_new_line
			end
		end

invariant

	output_not_void: output_file /= Void
	output_open_write: output_file.is_open_write

end
