indexing

	description:

		"Eiffel tagged indexing clauses"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "Eiffel Forum License v1 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ET_TAGGED_INDEXING

inherit

	ET_INDEXING
		rename
			make as make_untagged_indexing
		redefine
			tag
		end

creation

	make

feature {NONE} -- Initialization

	make (a_tag: like tag; a_terms: like terms) is
			-- Create a new tagged indexing clause.
		require
			a_tag_not_void: a_tag /= Void
			a_terms_not_void: a_terms /= Void
		do
			tag := a_tag
			terms := a_terms
		ensure
			tag_set: tag = a_tag
			terms_set: terms = a_terms
		end

feature -- Access

	tag: ET_TAG
			-- Tag

invariant

	tag_not_void: tag /= Void

end
