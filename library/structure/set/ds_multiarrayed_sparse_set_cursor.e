indexing

	description:

		"Cursors for multi-arrayed sparse set traversals"

	library:    "Gobo Eiffel Structure Library"
	author:     "Eric Bezault <ericb@gobosoft.com>"
	copyright:  "Copyright (c) 1999-2001, Eric Bezault and others"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

class DS_MULTIARRAYED_SPARSE_SET_CURSOR [G]

inherit

	DS_SPARSE_SET_CURSOR [G]
		redefine
			container
		end

creation

	make

feature -- Access

	container: DS_MULTIARRAYED_SPARSE_SET [G]
			-- Multi-arrayed sparse set traversed

end -- class DS_MULTIARRAYED_SPARSE_SET_CURSOR
