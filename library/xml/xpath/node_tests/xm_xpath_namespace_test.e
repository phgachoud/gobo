indexing

	description:

		"Objects that test for a node with a specific namespace-uri"

	library: "Gobo Eiffel XPath Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_XPATH_NAMESPACE_TEST

inherit

	XM_XPATH_NODE_TEST
		redefine
			node_kind
		end

	XM_XPATH_SHARED_NAME_POOL

creation

	make

feature {NONE} -- Initialization

	make (a_node_type: INTEGER; a_uri: STRING) is
		require
			uri_not_void: a_uri /= Void
		do
			node_kind := a_node_type
			if shared_name_pool.is_code_for_uri_allocated (a_uri) then
				uri_code := shared_name_pool.code_for_uri (a_uri)
			else
				shared_name_pool.allocate_code_for_uri (a_uri)
				uri_code := shared_name_pool.code_for_uri (a_uri)
			end
		ensure
			node_kind_set: node_kind = a_node_type
		end

feature -- Access

		node_kind: INTEGER
			-- Type of nodes to which this pattern applies

feature -- Status report

	allows_text_nodes: BOOLEAN is
			-- Does this node test allow text nodes?
		do
			Result := False
		end
	
feature -- Matching

	matches_node (a_node_kind: INTEGER; a_name_code: INTEGER; a_node_type: INTEGER): BOOLEAN is
			-- Is this node test satisfied by a given node?
		do

			if a_name_code = - 1 then
				Result := False
			elseif a_node_kind /= node_kind then
				Result := False
			else
				Result := uri_code = shared_name_pool.uri_code_from_name_code (a_name_code)
			end
		end

feature {NONE} -- Implementation

	uri_code: INTEGER
			-- The uri code
	
end
