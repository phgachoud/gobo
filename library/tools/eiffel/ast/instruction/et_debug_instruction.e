indexing

	description:

		"Eiffel debug instructions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2002, Eric Bezault and others"
	license: "Eiffel Forum License v1 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ET_DEBUG_INSTRUCTION

inherit

	ET_INSTRUCTION

creation

	make

feature {NONE} -- Initialization

	make (a_keys: like keys; a_compound: like compound) is
			-- Create a new debug instruction.
		do
			keys := a_keys
			compound := a_compound
			end_keyword := tokens.end_keyword
		ensure
			keys_set: keys = a_keys
			compound_set: compound = a_compound
		end

feature -- Access

	compound: ET_COMPOUND
			-- Debug instructions

	keys: ET_MANIFEST_STRING_LIST
			-- Debug keys

	end_keyword: ET_KEYWORD
			-- 'end' keyword

	position: ET_POSITION is
			-- Position of first character of
			-- current node in source code
		local
			a_debug_keyword: ET_KEYWORD
		do
			if compound /= Void then
				a_debug_keyword := compound.keyword
				if not a_debug_keyword.position.is_null then
					Result := a_debug_keyword.position
				elseif keys /= Void then
					Result := keys.position
				elseif not compound.is_empty then
					Result := compound.item (1).position
				else
					Result := end_keyword.position
				end
			elseif keys /= Void then
				Result := keys.position
			else
				Result := end_keyword.position
			end
		end

	break: ET_BREAK is
			-- Break which appears just after current node
		do
			Result := end_keyword.break
		end

feature -- Setting

	set_keys (a_keys: like keys) is
			-- Set `keys' to `a_keys'.
		do
			keys := a_keys
		ensure
			keys_set: keys = a_keys
		end

	set_end_keyword (an_end: like end_keyword) is
			-- Set `end_keyword' to `an_end'.
		require
			an_end_not_void: an_end /= Void
		do
			end_keyword := an_end
		ensure
			end_keyword_set: end_keyword = an_end
		end

feature -- Processing

	process (a_processor: ET_AST_PROCESSOR) is
			-- Process current node.
		do
			a_processor.process_debug_instruction (Current)
		end

invariant

	end_keyword_not_void: end_keyword /= Void

end
