indexing

	description:

		"Eiffel features"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2002, Eric Bezault and others"
	license: "Eiffel Forum License v1 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ET_FEATURE

inherit

	ET_AST_NODE

	HASHABLE

feature -- Access

	name: ET_FEATURE_NAME is
			-- Feature name
		do
			Result := name_item.feature_name
		ensure
			name_not_void: Result /= Void
		end

	current_class: ET_CLASS
			-- Class to which current feature belongs

	clients: ET_CLASS_NAME_LIST
			-- Clients to which feature is exported

	type: ET_TYPE is
			-- Return type;
			-- Void for procedures
		deferred
		end

	id: INTEGER
			-- Feature ID

	hash_code: INTEGER is
			-- Hash code value
		do
			Result := name.hash_code
		end

	version: INTEGER
			-- Version (feature ID of last declaration
			-- of current feature)

	first_seed: INTEGER
			-- First seed

	seeds: ET_FEATURE_IDS
			-- Seeds (feature IDs of first declarations
			-- of current feature); May be Void if there
			-- is only one seed (which is then accessible
			-- through `first_seed')

	first_precursor: INTEGER
			-- First precursor; 0 if current feature is
			-- immediate (i.e. not inherited nor redeclared)

	precursors: ET_FEATURE_IDS
			-- Precursors (feature IDs of corresponding
			-- to current feature in parents); Void if
			-- current feature is immediate (i.e. not
			-- inherited nor redeclared); May also be
			-- Void if there is only one precursor (which
			-- is then accessible through `first_precursor')

	implementation_class: ET_CLASS
			-- Class where implementation of current feature
			-- has been provided (Useful for interpreting
			-- feature calls and type anchors (that might
			-- be renamed in descendant classes) when feature
			-- is inherited as-is.)

	signature: ET_SIGNATURE is
			-- Signature of current feature
			-- (Create a new object at each call.)
		deferred
		ensure
			signature_not_void: Result /= Void
		end

	universe: ET_UNIVERSE is
			-- Universe to which current feature belongs
		do
			Result := current_class.universe
		ensure
			universe_not_void: Result /= Void
		end

	error_handler: ET_ERROR_HANDLER is
			-- Error handler
		do
			Result := universe.error_handler
		ensure
			error_handler_not_void: Result /= Void
		end

	name_item: ET_FEATURE_NAME_ITEM
			-- Feature name (possibly followed by comma for synomyms)

	frozen_keyword: ET_KEYWORD
			-- 'frozen' keyword

	feature_clause: ET_FEATURE_CLAUSE
			-- Feature clause containing current feature

	semicolon: ET_SEMICOLON_SYMBOL
			-- Optional semicolon in semicolon-separated list of features

	synonym: ET_FEATURE
			-- Next synonym if any

	position: ET_POSITION is
			-- Position of first character of
			-- current node in source code
		do
			if not is_frozen then
				Result := name.position
			else
				-- TODO:
				Result := name.position
			end
		end

feature -- Status report

	is_registered: BOOLEAN is
			-- Has feature been registered to the surrounding universe?
		do
			Result := (id > 0)
		ensure
			definition: Result = (id > 0)
		end

	is_frozen: BOOLEAN is
			-- Has feature been declared as frozen?
		do
			Result := (frozen_keyword /= Void)
		end

	is_deferred: BOOLEAN is
			-- Is feature deferred?
		do
			-- Result := False
		end

	is_attribute: BOOLEAN is
			-- Is feature an attribute?
		do
			-- Result := False
		end

	is_constant_attribute: BOOLEAN is
			-- Is feature a constant attribute?
		do
			-- Result := False
		end

	is_unique_attribute: BOOLEAN is
			-- Is feature a unique attribute?
		do
			-- Result := False
		end

	is_infixable: BOOLEAN is
			-- Can current feature have a name of
			-- the form 'infix ...'?
		do
			-- Result := False
		end

	is_prefixable: BOOLEAN is
			-- Can current feature have a name of
			-- the form 'prefix ...'?
		do
			-- Result := False
		end

	is_exported_to (a_class: ET_CLASS): BOOLEAN is
			-- Is current feature exported to `a_class'?
		require
			a_class_not_void: a_class /= Void
		do
			Result := clients.has_descendant (a_class)
		end

	is_creation_exported_to (a_class: ET_CLASS): BOOLEAN is
			-- Is current feature listed in the creation clauses
			-- of `current_class' and exported to `a_class'?
		require
			a_class_not_void: a_class /= Void
		do
			Result := current_class.is_creation_exported_to (name, a_class)
		end

	is_directly_exported_to (a_class: ET_CLASS): BOOLEAN is
			-- Does `a_class' appear in the list of clients of current feature?
			-- This is different from `is_exported_to' where `a_class' can
			-- be a descendant of a class appearing in the list of clients.
			-- Note: The use of 'direct' in the name of this feature has not
			-- the same meaning as 'direct and indirect client' in ETL2 p.91.
		require
			a_class_not_void: a_class /= Void
		do
			Result := clients.has (a_class)
		end

	is_creation_directly_exported_to (a_class: ET_CLASS): BOOLEAN is
			-- Is current feature listed in the creation clauses
			-- of `current_class' and directly exported to `a_class'?
			-- This is different from `is_creation_exported_to' where `a_class'
			-- can be a descendant of a class appearing in the list of clients.
			-- Note: The use of 'direct' in the name of this feature has not
			-- the same meaning as 'direct and indirect client' in ETL2 p.91.
		require
			a_class_not_void: a_class /= Void
		do
			Result := current_class.is_creation_directly_exported_to (name, a_class)
		end

feature -- Comparison

	same_version (other: ET_FEATURE): BOOLEAN is
			-- Do current feature and `other' have
			-- the same version?
		require
			other_not_void: other /= Void
		do
			Result := version = other.version
		ensure
			definition: Result = (version = other.version)
		end

feature -- Setting

	set_id (an_id: INTEGER) is
			-- Set `id' to `an_id'.
		require
			an_id_positive: an_id > 0
		do
			id := an_id
			if first_seed = 0 then
				set_first_seed (an_id)
			end
			if version = 0 then
				set_version (an_id)
			end
		ensure
			id_set: id = an_id
		end

	set_current_class (a_class: like current_class) is
			-- Set `current_class' to `a_class'.
		require
			a_class_not_void: a_class /= Void
		do
			current_class := a_class
		ensure
			current_class_set: current_class = a_class
		end

	set_feature_clause (a_feature_clause: like feature_clause) is
			-- Set `feature_clause' to `a_feature_clause'.
		do
			feature_clause := a_feature_clause
		ensure
			feature_clause_set: feature_clause = a_feature_clause
		end

	set_clients (a_clients: like clients) is
			-- Set `clients' to `a_clients'.
		require
			a_clients_not_void: a_clients /= Void
		do
			clients := a_clients
		ensure
			clients_set: clients = a_clients
		end

	set_version (a_version: INTEGER) is
			-- Set `version' to `a_version'.
		require
			a_version_not_void: a_version > 0
		do
			version := a_version
		ensure
			version_set: version = a_version
		end

	set_implementation_class (a_class: like implementation_class) is
			-- Set `implementation_class' to `a_class'.
		require
			a_class_not_void: a_class /= Void
		do
			implementation_class := a_class
		ensure
			implementation_class_set: implementation_class = a_class
		end

	set_first_seed (a_seed: INTEGER) is
			-- Set `first_seed' to `a_seed'.
		require
			a_seed_positive: a_seed > 0
		do
			seeds := Void
			first_seed := a_seed
		ensure
			first_seed_set: first_seed = a_seed
			only_one_seed: seeds = Void
		end

	set_seeds (a_seeds: like seeds) is
			-- Set `seeds' to `a_seeds'.
		require
			a_seeds_not_void: a_seeds /= Void
		do
			first_seed := a_seeds.first
			seeds := a_seeds
		ensure
			seeds_set: seeds = a_seeds
		end

	set_first_precursor (a_precursor: INTEGER) is
			-- Set `first_precursor' to `a_precursor'.
		do
			precursors := Void
			first_precursor := a_precursor
		ensure
			first_precursor_set: first_precursor = a_precursor
			only_one_precursor: precursors = Void
		end

	set_precursors (a_precursors: like precursors) is
			-- Set `precursors' to `a_precursors'.
		do
			if a_precursors /= Void then
				first_precursor := a_precursors.first
			else
				first_precursor := 0
			end
			precursors := a_precursors
		ensure
			precursors_set: precursors = a_precursors
		end

	set_frozen_keyword (a_frozen: like frozen_keyword) is
			-- Set `frozen_keyword' to `a_frozen'.
		do
			frozen_keyword := a_frozen
		ensure
			frozen_keyword_set: frozen_keyword = a_frozen
		end

	set_synonym (a_synonym: like synonym) is
			-- Set `synonym' to `a_synonym'.
		do
			synonym := a_synonym
		ensure
			synonym_set: a_synonym = a_synonym
		end

	set_semicolon (a_semicolon: like semicolon) is
			-- Set `semicolon' to `a_semicolon'.
		do
			semicolon := a_semicolon
		ensure
			semicolon_set: semicolon = a_semicolon
		end

feature -- Duplication

	new_synonym (a_name: like name_item): like Current is
			-- Synonym feature
		require
			a_name_not_void: a_name /= Void
		deferred
		ensure
			new_synonym_not_void: Result /= Void
			name_item_set: Result.name_item = a_name
		end

feature -- Conversion

	renamed_feature (a_name: like name): like Current is
			-- Renamed version of current feature
		require
			a_name_not_void: a_name /= Void
		deferred
		ensure
			renamed_feature_not_void: Result /= Void
			name_set: Result.name = a_name
		end

	undefined_feature (a_name: like name): ET_DEFERRED_ROUTINE is
			-- Undefined version of current feature
		require
			a_name_not_void: a_name /= Void
		deferred
		ensure
			undefined_feature_not_void: Result /= Void
			name_set: Result.name = a_name
			version_set: Result.version = Result.id
		end

feature -- System

	add_to_system is
			-- Recursively add to system classes that
			-- appear in current feature.
		deferred
		end

feature -- Type processing

	has_formal_parameters (actual_parameters: ET_ACTUAL_PARAMETER_LIST): BOOLEAN is
			-- Does current feature contain formal generic parameter
			-- types whose corresponding actual parameter in
			-- `actual_parameters' is different from the formal
			-- parameter?
		require
			actual_parameters_not_void: actual_parameters /= Void
		deferred
		end

	resolve_formal_parameters (actual_parameters: ET_ACTUAL_PARAMETER_LIST) is
			-- Replace in current feature the formal generic parameter
			-- types by those of `actual_parameters' when the 
			-- corresponding actual parameter is different from
			-- the formal parameter.
		require
			actual_parameters_not_void: actual_parameters /= Void
		deferred
		end

	resolve_identifier_types (a_class: ET_CLASS) is
			-- Replace any 'like identifier' types that appear in the
			-- implementation of current feature in class `a_class' by
			-- the corresponding 'like feature' or 'like argument'.
			-- Also resolve 'BIT identifier' types and check validity
			-- of arguments' name. Set `a_class.has_flatten_error' to
			-- true if an error occurs.
		require
			a_class_not_void: a_class /= Void
			immediate_or_redeclared: implementation_class = a_class
		deferred
		end

invariant

	name_item_not_void: name_item /= Void
	current_class_not_void: current_class /= Void
	clients_not_void: clients /= Void
	first_seed_positive: is_registered implies first_seed > 0
	first_seed_definition: seeds /= Void implies first_seed = seeds.first
	first_precursor_definition: precursors /= Void implies first_precursor = precursors.first
	implementation_class_not_void: implementation_class /= Void

end
