indexing

	description:

		"xsl:namespace element nodes"

	library: "Gobo Eiffel XSLT Library"
	copyright: "Copyright (c) 2005, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_XSLT_NAMESPACE

inherit

	XM_XSLT_STRING_CONSTRUCTOR
		redefine
			validate, make_style_element
		end

create {XM_XSLT_NODE_FACTORY}

	make_style_element

feature {NONE} -- Initialization
	
	make_style_element (an_error_listener: XM_XSLT_ERROR_LISTENER; a_document: XM_XPATH_TREE_DOCUMENT;  a_parent: XM_XPATH_TREE_COMPOSITE_NODE;
		an_attribute_collection: XM_XPATH_ATTRIBUTE_COLLECTION; a_namespace_list:  DS_ARRAYED_LIST [INTEGER];
		a_name_code: INTEGER; a_sequence_number: INTEGER; a_configuration: like configuration) is
			-- Establish invariant.
		do
			is_instruction := True
			Precursor (an_error_listener, a_document, a_parent, an_attribute_collection, a_namespace_list, a_name_code, a_sequence_number, a_configuration)
		end

feature -- Access

	name: XM_XPATH_EXPRESSION
			-- Name (prefix) to be generated

	select_and_content_error: STRING is
			-- Error code when both select expression and content are mutually exclusive
		do
			Result := "XTSE0910"
		end

feature -- Element change

	prepare_attributes is
			-- Set the attribute list for the element.
		local
			a_cursor: DS_ARRAYED_LIST_CURSOR [INTEGER]
			a_name_code: INTEGER
			an_expanded_name, a_name_attribute, a_select_attribute: STRING
		do
			from
				a_cursor := attribute_collection.name_code_cursor
				a_cursor.start
			variant
				attribute_collection.number_of_attributes + 1 - a_cursor.index				
			until
				a_cursor.after
			loop
				a_name_code := a_cursor.item
				an_expanded_name := shared_name_pool.expanded_name_from_name_code (a_name_code)
				if STRING_.same_string (an_expanded_name, Name_attribute) then
					a_name_attribute := attribute_value_by_index (a_cursor.index)
					STRING_.left_adjust (a_name_attribute)
					STRING_.right_adjust (a_name_attribute)
				elseif STRING_.same_string (an_expanded_name, Select_attribute) then
					a_select_attribute := attribute_value_by_index (a_cursor.index)
					STRING_.left_adjust (a_select_attribute)
					STRING_.right_adjust (a_select_attribute)
				else
					check_unknown_attribute (a_name_code)
				end
				a_cursor.forth
			end
			if a_name_attribute = Void then
				report_absence ("name")
			else
				generate_attribute_value_template (a_name_attribute, static_context)
				name := last_generated_expression
			end
			if a_select_attribute /= Void then
				generate_expression (a_select_attribute)
				select_expression := last_generated_expression
				if select_expression.is_error then
					report_compile_error (select_expression.error_value)
				end
			end
			attributes_prepared := True
		end

	validate is
			-- Check that the stylesheet element is valid.
		do
			check_within_template
			type_check_expression ("name", name)
			if name.was_expression_replaced then
				name := name.replacement_expression
			end
			if select_expression /= Void then
				type_check_expression ("select", select_expression)
				if select_expression.was_expression_replaced then
					select_expression := select_expression.replacement_expression
				end
			end
			Precursor
		end

	compile (an_executable: XM_XSLT_EXECUTABLE) is
			-- Compile `Current' to an excutable instruction.
		local
			a_namespace: XM_XSLT_COMPILED_NAMESPACE
			a_string_value: XM_XPATH_STRING_VALUE
		do
			create a_namespace.make (an_executable, name)
			create a_string_value.make (" ")
			compile_content (an_executable, a_namespace, a_string_value)
			last_generated_expression := a_namespace
		end

end
