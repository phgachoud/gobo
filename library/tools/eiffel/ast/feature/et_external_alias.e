indexing

	description:

		"Eiffel alias clauses in external routines"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "Eiffel Forum License v1 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ET_EXTERNAL_ALIAS

inherit

	ET_AST_NODE

feature -- Access

	manifest_string: ET_MANIFEST_STRING is
			-- External alias
		deferred
		ensure
			manifest_string_not_void: Result /= Void
		end

end
