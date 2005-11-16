indexing

	description:

		"A concatenation of two XPath Expressions (comma operator)"

	library: "Gobo Eiffel XPath Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_XPATH_APPEND_EXPRESSION

inherit

	XM_XPATH_BINARY_EXPRESSION
		redefine
			compute_cardinality, simplify, create_iterator, make,
			is_append_expression, as_append_expression
		end

	XM_XPATH_TOKENS
		export {NONE} all end
	
create

	make

feature {NONE} -- Initialization

	make (an_operand_one: XM_XPATH_EXPRESSION; a_token: INTEGER; an_operand_two: XM_XPATH_EXPRESSION) is
			-- Establish invariant
		do
			Precursor (an_operand_one, a_token, an_operand_two)
			initialized := True
		end

feature -- Access

	is_append_expression: BOOLEAN is
			-- Is `Current' a append expression?
		do
			Result := True
		end

	as_append_expression: XM_XPATH_APPEND_EXPRESSION is
			-- `Current' seen as a append expression
		do
			Result := Current
		end

	frozen item_type: XM_XPATH_ITEM_TYPE is
			--Determine the data type of the expression, if possible
		do
			Result := common_super_type (first_operand.item_type, second_operand.item_type)
			if Result /= Void then
				-- Bug in SE 1.0 and 1.1: Make sure that
				-- that `Result' is not optimized away.
			end
		end

feature -- Optimization	

	simplify is
			-- Perform context-independent static optimizations.
		local
			an_append_expression, another_append_expression, a_third_append_expression: XM_XPATH_APPEND_EXPRESSION
			a_sequence_extent: XM_XPATH_SEQUENCE_EXTENT
			an_expression: XM_XPATH_EXPRESSION
			an_invalid_value: XM_XPATH_INVALID_VALUE
		do
			first_operand.simplify
			if first_operand.is_error then
				set_last_error (first_operand.error_value)
			elseif first_operand.was_expression_replaced then
				set_first_operand (first_operand.replacement_expression)
			end

			if is_error then
				second_operand.simplify
				if second_operand.is_error then
					set_last_error (second_operand.error_value)
				elseif second_operand.was_expression_replaced then
					set_second_operand (second_operand.replacement_expression)
				end
			end

			if not is_error then
				if first_operand.is_empty_sequence then
					 set_replacement (second_operand)
				else
					if second_operand.is_empty_sequence then
						set_replacement (first_operand)
					else

						-- For lists consisting entirely of constant atomic values, build a sequence extent at compile time

						if is_atomic_sequence then
							create_iterator (Void)
							if last_iterator.is_error then
								create an_invalid_value.make (last_iterator.error_value)
								set_replacement (an_invalid_value)
							else
								create a_sequence_extent.make (last_iterator)
								set_replacement (a_sequence_extent)
							end
						else

							-- An expression such as (1,2,$x) will be parsed as (1, (2, $x)). This can be
							--  simplified to ((1,2), $x), reducing the number of iterators needed to evaluate it

							if first_operand.is_value and then second_operand.is_append_expression then
								another_append_expression := second_operand.as_append_expression
								if another_append_expression.first_operand.is_value then
									an_expression := another_append_expression.first_operand; an_expression.simplify
									if an_expression.is_error then
										set_replacement (an_expression)
									elseif an_expression.was_expression_replaced then
										an_expression := an_expression.replacement_expression
									else
										create a_third_append_expression.make (first_operand, operator, an_expression)
										an_expression := another_append_expression.second_operand; an_expression.simplify
										if an_expression.is_error then
											set_replacement (an_expression)
										elseif an_expression.was_expression_replaced then
											an_expression := an_expression.replacement_expression											
										end
										if not was_expression_replaced then
											create {XM_XPATH_APPEND_EXPRESSION} an_append_expression.make (a_third_append_expression, operator, an_expression)
											set_replacement (an_append_expression)
										end
									end
								end
							end
						end
					end
				end
			end
		end

feature -- Evaluation

	create_iterator (a_context: XM_XPATH_CONTEXT) is
			-- Iterator over the values of a sequence
		do
			first_operand.create_iterator (a_context)
			if first_operand.last_iterator.is_error then
				last_iterator := first_operand.last_iterator
			else
				second_operand.create_iterator (a_context)
				if second_operand.last_iterator.is_error then
					last_iterator := second_operand.last_iterator
				else
					create {XM_XPATH_APPEND_ITERATOR} last_iterator.make (first_operand.last_iterator, second_operand.last_iterator, a_context)
				end
			end
		end

feature {NONE} -- Implementation

	compute_cardinality is
			-- Compute cardinality.
		do
			if first_operand.is_empty_sequence then
				clone_cardinality (second_operand)
			else
				if second_operand.is_empty_sequence then
					clone_cardinality (first_operand)
				else
					if first_operand.cardinality_allows_zero and then second_operand.cardinality_allows_zero then
						set_cardinality_zero_or_more
					else
						set_cardinality_one_or_more 
					end
				end
			end
			are_cardinalities_computed := True
		end

	is_atomic_sequence: BOOLEAN is
			-- Is `Current' an atomic sequence?
		do
			Result := is_atomic (first_operand) and then  is_atomic (second_operand) 
		end

	is_atomic (an_expression: XM_XPATH_EXPRESSION): BOOLEAN is
			-- Is `an_expression' atomic or an atomic extent?
		do
			if an_expression.is_atomic_value then
				Result := True
			elseif an_expression.is_sequence_extent then
					Result := True
			end
		end

end
	