indexing

	description:

		"TBA"

	library: "Gobo Eiffel XSLT Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_XSLT_COMPARISON_KEY

inherit

	HASHABLE

	XM_XPATH_TYPE

creation

	make, make_nan, make_numeric, make_with_collation_key

feature {NONE} -- Initialization

	make_nan is
			-- Establish invariant.
		do
			category := Numeric_type_code
			is_nan := True
		ensure
			nan: is_nan
		end

	make_numeric (a_numeric_value: XM_XPATH_NUMERIC_VALUE) is
			-- Establish invariant.
		require
			value_not_void: a_numeric_value /= Void
		do
			category := Numeric_type_code
			value := a_numeric_value
		ensure
			value_set: value = a_numeric_value
			not_nan: not is_nan
		end

	make_with_collation_key (a_collation_key: ST_COLLATION_KEY) is
			-- Establish invariant.
		require
			collation_key_not_void: a_collation_key /= Void
		do
			collation_key := a_collation_key
		ensure
			collation_key_set: collation_key = a_collation_key
			not_nan: not is_nan
		end

	make (an_atomic_value: XM_XPATH_ATOMIC_VALUE) is
		require
			value_not_void: an_atomic_value /= Void
		do
			category := an_atomic_value.item_type.primitive_type
			value := an_atomic_value
		ensure
			value_set: value = an_atomic_value
			not_nan: not is_nan
		end

feature -- Access

	hash_code: INTEGER is
			-- Hash code value
		do
			if is_nan then
				Result := 0
			elseif collation_key /= Void then
				Result := collation_key.hash_code
			else
				Result := value.hash_code
			end
		end

feature -- Comparison

	same_key (other: XM_XSLT_COMPARISON_KEY): BOOLEAN is
			-- Are `Current' and `other' considered equal?
		require
			other_not_void: other /= Void
		do
			if is_nan then
				Result := other.is_nan
			elseif collation_key /= Void then
				Result := other.collation_key /= Void and then collation_key.three_way_comparison (other.collation_key) = 0
			elseif category = other.category then
				Result := value.same_expression (other.value)
			end
		end

feature {XM_XSLT_COMPARISON_KEY} -- Implementation

	category: INTEGER
			-- Category

	value: XM_XPATH_ATOMIC_VALUE
			-- Value

	collation_key: ST_COLLATION_KEY
			-- Collation key

	is_nan: BOOLEAN
			-- is this NaN?

invariant

	nan: is_nan implies value /= Void and then category = Numeric_type_code
	value: collation_key = Void implies value /= Void
	collation_key: collation_key /= Void implies value = Void
	
end
	
