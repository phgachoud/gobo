indexing

	description: 

		"Entity definition and scanner"

	note:

		"This class represents an entity name/type and also a scanner for this %
		%entity. The two concepts could be distinct, but this helps enforcing %
		%the property that an entity cannot be recursively included, as the %
		%scanner can be checked for being in use if the entity is recursively %
		%included. This is not really a is-a relationship though."

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_EIFFEL_ENTITY_DEF

inherit

	HASHABLE

	XM_EIFFEL_SCANNER
		redefine
			reset, read_token,
			normalized_newline,
			has_normalized_newline
		end
		
	UC_IMPORTED_UTF8_ROUTINES
		export {NONE} all end

creation

	make_literal,
	make_external,
	make_def

feature {NONE} -- Initialization

	make_literal (a_value: STRING) is
			-- Create a new literal entity definition from `a_value'.
		require
			a_value_not_void: a_value /= Void
		do
			value := a_value
			make_scanner
			create {XM_NULL_EXTERNAL_RESOLVER} resolver
		ensure
			is_literal: is_literal
			value_set: value = a_value
		end

	make_external (a_resolver: like resolver; a_value: STRING) is
			-- Create a new external entity definition from `a_value'.
		require
			a_resolver_not_void: a_resolver /= Void
			a_value_not_void: a_value /= Void
		do
			is_external := True
			resolver := a_resolver
			value := a_value
			make_scanner
		ensure
			is_external: is_external
			value_set: value = a_value
			resolver_set: resolver = a_resolver
		end

	make_def (other: XM_EIFFEL_ENTITY_DEF) is
			-- Create a new entity definition from `other'.
		require
			other_not_void: other /= Void
		do
			if other.is_external then
				make_external (other.resolver, other.value)
			else
				make_literal (other.value)
			end
		ensure
			is_external: is_external = other.is_external
			is_literal: is_literal = other.is_literal
			value_set: value = other.value
		end

feature -- Resolver

	resolver: XM_EXTERNAL_RESOLVER
	
feature -- Status report

	is_external: BOOLEAN
			-- Is current entity an external entity?

	is_literal: BOOLEAN is
			-- Is current entity a literal entity?
		do
			Result := not is_external
		ensure
			definition: Result = not is_external
		end

feature -- Access

	value: STRING
			-- Value

	external_value: STRING is
			-- Resolve external value.
			-- Place holder.
		require
			is_external: is_external
		do
			Result := value
		end

	hash_code: INTEGER is
			-- Hash code value
			-- (on the entity name aspect)
		do
			Result := value.hash_code // 2
			if is_external then
				Result := Result + 1
			end
		end

feature -- Scanner: set input buffer

	apply_input_buffer is
			-- Set input buffer.
		do
			if in_use then
				fatal_error (Error_recursive_entity)
			elseif is_literal then
					-- Literal string.
				reset
				-- the value we get may be UC_STRING, so it must be
				-- converted back to UTF8 for the scanner which operates 
				-- on UTF8-in-STRING input
				set_input_buffer (new_string_buffer (utf8.to_utf8(value)))
			else
					-- External entity in a file.
				reset
				resolver.resolve (external_value)
				if not resolver.has_error then
					set_input_stream (resolver.last_stream)
					-- `has_error'/`last_error' set by `set_input_file'.
				else
					fatal_error (resolver.last_error)
				end
			end
		end

feature {NONE} -- Newline normalization

	normalized_newline: STRING is
			-- Newline normalized text (2.11)
		do
				-- Newline normalization has already been applied
				-- to a literal entity and should not be applied 
				-- again, e.g. for literal entities which contain 
				-- character entities of newline characters which 
				-- should get out as is.
			if is_literal then
				Result := text
			else
				Result := Precursor
			end
		end

	has_normalized_newline: BOOLEAN is
			-- Has newline normalization already been applied?
		do
				-- Newline normalization has already been applied
				-- to a literal entity and should not be applied 
				-- again, e.g. for literal entities which contain 
				-- character entities of newline characters which 
				-- should get out as is.
			Result := is_literal
		end

feature -- Scanner: events

	in_use: BOOLEAN
			-- Has the first token been processed?

	read_token is
			-- Ignore XML declaration that may be at the start of an external entity.
			-- Also that places the content of an external DTD within
			-- a (DOCTYPE_DECL_START, DOCTYPE_DECL_END) token pair.
		local
			done: BOOLEAN
			enc_count, vers_count: INTEGER
		do
			Precursor
			if not in_use then
					-- Processing on first token read.
				in_use := True
				if is_external and last_token = XMLDECLARATION_START then
						-- Micro parser to skip xml declaration.
					from until
						end_of_file or done
					loop
						Precursor
						if last_token = XMLDECLARATION_ENCODING then
							enc_count := enc_count + 1
						elseif last_token = XMLDECLARATION_VERSION then
							vers_count := vers_count + 1
						elseif last_token = SPACE or last_token = APOS 
							or last_token = QUOT or last_token = XMLDECLARATION_ENCODING_VALUE
						then
							-- Continue.
						elseif last_token = XMLDECLARATION_END then
							if enc_count = 1 and vers_count <= 1 then
									-- Valid, skip this else leave for error.
								Precursor
							end
							done := True
						else
								-- Exit and error.
							done := True
						end
					end
				end
			end
				-- Reset in use flag.
			if end_of_file then
				in_use := False
			end
		end

feature -- Scanner: initialization

	reset is
			-- Reset first seen status.
		do
			Precursor
			in_use := False
		end

invariant

	value_not_void: value /= Void
	resolver_not_void: resolver /= Void
	type: is_literal xor is_external

end
