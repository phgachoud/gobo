indexing

	description:

		"Eiffel class feature flatteners"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2001-2003, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ET_FEATURE_FLATTENER

inherit

	ET_CLASS_PROCESSOR
		redefine
			make
		end

	ET_SHARED_FEATURE_NAME_TESTER

	ET_SHARED_CLASS_NAME_TESTER

creation

	make

feature {NONE} -- Initialization

	make (a_universe: like universe) is
			-- Create a new feature flattener for classes in `a_universe'.
		do
			precursor (a_universe)
			create named_features.make_map (400)
			named_features.set_key_equality_tester (feature_name_tester)
			create rename_table.make (10)
			rename_table.set_key_equality_tester (feature_name_tester)
			create undefine_table.make (10)
			undefine_table.set_equality_tester (feature_name_tester)
			create redefine_table.make (10)
			redefine_table.set_equality_tester (feature_name_tester)
			create select_table.make (10)
			select_table.set_equality_tester (feature_name_tester)
			create replicable_features.make_map (400)
			create clients_list.make (20)
			create client_names.make (20)
			client_names.set_equality_tester (class_name_tester)
			create identifier_type_resolver.make (Current)
			create anchored_type_checker.make (Current)
			create parent_checker.make (Current)
			create formal_parameter_checker.make (Current)
			create parent_context.make (a_universe.any_class, a_universe.any_class)
		end

feature -- Access

	degree: STRING is "4.2"
			-- ISE's style degree of current processor

feature -- Error handling

	set_fatal_error (a_class: ET_CLASS) is
			-- Report a fatal error to `a_class'.
		do
			a_class.set_features_flattened
			a_class.set_flattening_error
		ensure then
			features_flattened: a_class.features_flattened
			has_flattening_error: a_class.has_flattening_error
		end

feature -- Processing

	process_class (a_class: ET_CLASS) is
			-- Build ancestors of `a_class' if not already done.
			-- Then run second pass of the formal generic parameters
			-- validity check of `a_class', and the second pass of
			-- the parent validity check. And finally, flatten the
			-- feature table of `a_class'.
		local
			a_processor: like Current
		do
			if a_class = none_class then
				a_class.set_features_flattened
			elseif current_class /= unknown_class then
					-- TODO: Internal error (recursive call)
print ("INTERNAL ERROR%N")
				create a_processor.make (universe)
				a_processor.process_class (a_class)
			elseif a_class /= unknown_class then
				internal_process_class (a_class)
			end
		ensure then
			features_flattened: a_class.features_flattened
		end

feature {NONE} -- Processing

	internal_process_class (a_class: ET_CLASS) is
			-- Build ancestors of `a_class' if not already done.
			-- Then run second pass of the formal generic parameters
			-- validity check of `a_class', and the second pass of
			-- the parent validity check. And finally, flatten the
			-- feature table of `a_class'.
		require
			a_class_not_void: a_class /= Void
		local
			old_class: ET_CLASS
			a_parents: ET_PARENT_LIST
			a_parent_class: ET_CLASS
			i, nb: INTEGER
		do
			old_class := current_class
			current_class := a_class
			if not current_class.features_flattened then
					-- Build ancestors of `current_class' if not already done.
				current_class.process (universe.ancestor_builder)
				if not current_class.has_ancestors_error then
					current_class.set_features_flattened
						-- Process parents first.
					a_parents := current_class.parents
					if a_parents = Void or else a_parents.is_empty then
						if current_class = universe.general_class then
							a_parents := Void
						elseif current_class = universe.any_class then
								-- ISE Eiffel has no GENERAL class anymore.
								-- Use ANY has class root now.
							a_parents := Void
						else
							a_parents := universe.any_parents
						end
					end
					if a_parents /= Void then
						nb := a_parents.count
						from i := 1 until i > nb loop
								-- This is a controlled recursive call to `internal_process_class'.
							a_parent_class := a_parents.parent (i).type.direct_base_class (universe)
							internal_process_class (a_parent_class)
							if a_parent_class.has_flattening_error then
								set_fatal_error (current_class)
							end
							i := i + 1
						end
					end
					if not current_class.has_flattening_error then
						error_handler.report_compilation_status (Current)
							-- Check validity rules of the parents and of formal
							-- generic parameters of `current_class'.
						check_formal_parameters_validity
						check_parents_validity
					end
					if not current_class.has_flattening_error then
						add_current_features
						if a_parents /= Void then
							from i := 1 until i > nb loop
								add_inherited_features (a_parents.parent (i))
								i := i + 1
							end
						end
						flatten_features
						if a_parents /= Void then
							from i := 1 until i > nb loop
								cleanup_inherited_features (a_parents.parent (i))
								i := i + 1
							end
						end
					end
				else
					set_fatal_error (current_class)
				end
			end
			current_class := old_class
		ensure
			features_flattened: a_class.features_flattened
		end

feature {NONE} -- Feature recording

	named_features: DS_HASH_TABLE [ET_FEATURE, ET_FEATURE_NAME]
			-- Features indexed by name

	new_features_count: INTEGER
			-- Number of features which appear in one
			-- of the feature clauses of `current_class'

	add_current_features is
			-- Add to `named_features' features declared in `current_class'.
		local
			a_feature, other_feature: ET_FEATURE
			a_name: ET_FEATURE_NAME
			class_features: ET_FEATURE_LIST
			i, nb: INTEGER
		do
			class_features := current_class.features
			nb := class_features.count
			if named_features.capacity < nb then
				named_features.resize (nb)
			end
			from i := 1 until i > nb loop
				a_feature := class_features.item (i)
				a_name := a_feature.name
				named_features.search (a_name)
				if named_features.found then
					other_feature := named_features.found_item
					set_fatal_error (current_class)
					error_handler.report_vmfna_error (current_class, other_feature, a_feature)
				else
					named_features.put_last (a_feature, a_name)
				end
				i := i + 1
			end
			new_features_count := named_features.count
		end

	add_inherited_features (a_parent: ET_PARENT) is
			-- Add to `named_features' features inherited from `a_parent'.
			-- Also process the Feature_adaptation clause of `a_parent'.
			-- `a_parent' is one of the parents, explicit or implicit
			-- (i.e. ANY), of `current_class'.
		require
			a_parent_not_void: a_parent /= Void
		local
			a_class: ET_CLASS
			has_rename: BOOLEAN
			has_redefine: BOOLEAN
			has_undefine: BOOLEAN
			has_select: BOOLEAN
			class_features: ET_FEATURE_LIST
			a_feature: ET_FEATURE
			a_flattened_feature: ET_FLATTENED_FEATURE
			a_named_feature: ET_FEATURE
			a_redeclared_feature: ET_REDECLARED_FEATURE
			an_inherited_feature: ET_INHERITED_FEATURE
			a_name: ET_FEATURE_NAME
			a_rename: ET_RENAME
			i, nb: INTEGER
		do
			if a_parent.renames /= Void then
				has_rename := True
				fill_rename_table (a_parent)
			end
			if a_parent.redefines /= Void then
				has_redefine := True
				fill_redefine_table (a_parent)
			end
			if a_parent.undefines /= Void then
				has_undefine := True
				fill_undefine_table (a_parent)
			end
			if a_parent.selects /= Void then
				has_select := True
				fill_select_table (a_parent)
			end
			a_class := a_parent.type.direct_base_class (universe)
			class_features := a_class.features
			nb := class_features.count + named_features.count
			if named_features.capacity < nb then
				named_features.resize (nb)
			end
			nb := class_features.count
			from i := 1 until i > nb loop
				an_inherited_feature := Void
					-- Call `flattened_feature' because some inherited features
					-- may still not be fully processed yet (if they contain
					-- qualified type "like a.b" for example).
				a_flattened_feature := class_features.item (i).flattened_feature
				a_name := a_flattened_feature.name
				if has_rename then
					rename_table.search (a_name)
					if rename_table.found then
						a_rename := rename_table.found_item
						rename_table.remove_found_item
						if an_inherited_feature = Void then
							create an_inherited_feature.make (a_flattened_feature, a_parent)
						end
						an_inherited_feature.set_new_name (a_rename)
						a_name := a_rename.new_name
					end
				end
				if has_undefine then
					undefine_table.search (a_name)
					if undefine_table.found then
						if an_inherited_feature = Void then
							create an_inherited_feature.make (a_flattened_feature, a_parent)
						end
						an_inherited_feature.set_undefine_name (undefine_table.found_item)
						undefine_table.remove_found_item
					end
				end
				if has_redefine then
					redefine_table.search (a_name)
					if redefine_table.found then
						if an_inherited_feature = Void then
							create an_inherited_feature.make (a_flattened_feature, a_parent)
						end
						an_inherited_feature.set_redefine_name (redefine_table.found_item)
						redefine_table.remove_found_item
					end
				end
				if has_select then
					select_table.search (a_name)
					if select_table.found then
						if an_inherited_feature = Void then
							create an_inherited_feature.make (a_flattened_feature, a_parent)
						end
						an_inherited_feature.set_select_name (select_table.found_item)
						select_table.remove_found_item
					end
				end
				if an_inherited_feature /= Void then
					a_feature := an_inherited_feature
				elseif not a_flattened_feature.is_inherited then
					a_flattened_feature.set_parent (a_parent)
					a_feature := a_flattened_feature
				else
						-- TODO: try to avoid creating this object
						-- when the inherited feature is actually
						-- shared. In that case we don't care if the
						-- feature comes from one parent or another.
					create an_inherited_feature.make (a_flattened_feature, a_parent)
					a_feature := an_inherited_feature
				end
				named_features.search (a_name)
				if named_features.found then
					a_named_feature := named_features.found_item
					if not a_named_feature.is_inherited then
						create a_redeclared_feature.make (a_named_feature.flattened_feature, a_feature)
						named_features.replace_found_item (a_redeclared_feature)
					elseif a_named_feature.is_redeclared then
						a_redeclared_feature := a_named_feature.redeclared_feature
						a_redeclared_feature.put_inherited_feature (a_feature)
					else
						an_inherited_feature := a_named_feature.inherited_feature
						an_inherited_feature.put_inherited_feature (a_feature)
						if an_inherited_feature /= a_named_feature then
							named_features.replace_found_item (an_inherited_feature)
						end
					end
				else
					named_features.put_last (a_feature, a_name)
				end
				i := i + 1
			end
			if not rename_table.is_empty then
				from rename_table.start until rename_table.after loop
					a_rename := rename_table.item_for_iteration
					set_fatal_error (current_class)
					error_handler.report_vhrc1_error (current_class, a_parent, a_rename)
					rename_table.forth
				end
				rename_table.wipe_out
			end
			if not undefine_table.is_empty then
				from undefine_table.start until undefine_table.after loop
					a_name := undefine_table.item_for_iteration
					set_fatal_error (current_class)
					error_handler.report_vdus1_error (current_class, a_parent, a_name)
					undefine_table.forth
				end
				undefine_table.wipe_out
			end
			if not redefine_table.is_empty then
				from redefine_table.start until redefine_table.after loop
					a_name := redefine_table.item_for_iteration
					set_fatal_error (current_class)
					error_handler.report_vdrs1_error (current_class, a_parent, a_name)
					redefine_table.forth
				end
				redefine_table.wipe_out
			end
			if not select_table.is_empty then
				from select_table.start until select_table.after loop
					a_name := select_table.item_for_iteration
					set_fatal_error (current_class)
					error_handler.report_vmss1_error (current_class, a_parent, a_name)
					select_table.forth
				end
				select_table.wipe_out
			end
		end

	cleanup_inherited_features (a_parent: ET_PARENT) is
			-- Unset `parent' in the features inherited from `a_parent'.
		require
			a_parent_not_void: a_parent /= Void
		local
			a_class: ET_CLASS
			class_features: ET_FEATURE_LIST
			a_feature: ET_FEATURE
			i, nb: INTEGER
		do
			a_class := a_parent.type.direct_base_class (universe)
			class_features := a_class.features
			nb := class_features.count
			from i := 1 until i > nb loop
				a_feature := class_features.item (i)
				if a_feature.is_inherited and a_feature.is_flattened then
					a_feature.unset_parent
				end
				i := i + 1
			end
		end

feature {NONE} -- Feature adaptation

	rename_table: DS_HASH_TABLE [ET_RENAME, ET_FEATURE_NAME]
			-- Rename table

	undefine_table: DS_HASH_SET [ET_FEATURE_NAME]
			-- Undefine table

	redefine_table: DS_HASH_SET [ET_FEATURE_NAME]
			-- Redefine table

	select_table: DS_HASH_SET [ET_FEATURE_NAME]
			-- Select table

	fill_rename_table (a_parent: ET_PARENT) is
			-- Fill `rename_table' with rename pairs of `a_parent'
			-- indexed by their old_name.
		require
			a_parent_not_void: a_parent /= Void
			renames_not_void: a_parent.renames /= Void
		local
			i, nb: INTEGER
			a_renames: ET_RENAME_LIST
			a_rename: ET_RENAME
			a_name: ET_FEATURE_NAME
		do
			a_renames := a_parent.renames
			nb := a_renames.count
			if rename_table.capacity < nb then
				rename_table.resize (nb)
			end
			from i := 1 until i > nb loop
				a_rename := a_renames.rename_pair (i)
				a_name := a_rename.old_name
				rename_table.search (a_name)
				if not rename_table.found then
					rename_table.put (a_rename, a_name)
				else
						-- Feature name `a_name' appears twice on the
						-- left-hand-side of a Rename_pair in the Rename
						-- clause.
					if not rename_table.found_item.new_name.same_feature_name (a_rename.new_name) then
							-- The two Rename_pairs have a different `new_name'.
							-- The flatten process will have to fail.
						set_fatal_error (current_class)
					end
					error_handler.report_vhrc2_error (current_class, a_parent, rename_table.found_item, a_rename)
				end
				i := i + 1
			end
		end

	fill_undefine_table (a_parent: ET_PARENT) is
			-- Fill `undefine_table' with undefined names of `a_parent'.
		require
			a_parent_not_void: a_parent /= Void
			undefines_not_void: a_parent.undefines /= Void
		local
			i, nb: INTEGER
			a_undefines: ET_KEYWORD_FEATURE_NAME_LIST
			a_name: ET_FEATURE_NAME
		do
			a_undefines := a_parent.undefines
			nb := a_undefines.count
			if undefine_table.capacity < nb then
				undefine_table.resize (nb)
			end
			from i := 1 until i > nb loop
				a_name := a_undefines.feature_name (i)
				undefine_table.search (a_name)
				if not undefine_table.found then
					undefine_table.put_new (a_name)
				else
						-- Feature name `a_name' appears twice in the
						-- Undefine clause. This is not considered as
						-- a fatal error by gelint.
					error_handler.report_vdus4_error (current_class, a_parent, undefine_table.found_item, a_name)
				end
				i := i + 1
			end
		end

	fill_redefine_table (a_parent: ET_PARENT) is
			-- Fill `redefine_table' with redefined names of `a_parent'.
		require
			a_parent_not_void: a_parent /= Void
			redefines_not_void: a_parent.redefines /= Void
		local
			i, nb: INTEGER
			a_redefines: ET_KEYWORD_FEATURE_NAME_LIST
			a_name: ET_FEATURE_NAME
		do
			a_redefines := a_parent.redefines
			nb := a_redefines.count
			if redefine_table.capacity < nb then
				redefine_table.resize (nb)
			end
			from i := 1 until i > nb loop
				a_name := a_redefines.feature_name (i)
				redefine_table.search (a_name)
				if not redefine_table.found then
					redefine_table.put_new (a_name)
				else
						-- Feature name `a_name' appears twice in the
						-- Redefine clause. This is not considered as
						-- a fatal error by gelint.
					error_handler.report_vdrs3_error (current_class, a_parent, redefine_table.found_item, a_name)
				end
				i := i + 1
			end
		end

	fill_select_table (a_parent: ET_PARENT) is
			-- Fill `select_table' with selected names of `a_parent'.
		require
			a_parent_not_void: a_parent /= Void
			selects_not_void: a_parent.selects /= Void
		local
			i, nb: INTEGER
			a_selects: ET_KEYWORD_FEATURE_NAME_LIST
			a_name: ET_FEATURE_NAME
		do
			a_selects := a_parent.selects
			nb := a_selects.count
			if select_table.capacity < nb then
				select_table.resize (nb)
			end
			from i := 1 until i > nb loop
				a_name := a_selects.feature_name (i)
				select_table.search (a_name)
				if not select_table.found then
					select_table.put_new (a_name)
				else
						-- Feature name `a_name' appears twice in the
						-- Select clause. This is not considered as
						-- a fatal error by gelint.
					error_handler.report_vmss2_error (current_class, a_parent, select_table.found_item, a_name)
				end
				i := i + 1
			end
		end

feature {NONE} -- Feature flattening

	flatten_features is
			-- Flatten inherited features into `current_class'.
		local
			class_features: ET_FEATURE_LIST
			a_feature: ET_FEATURE
			i, nb: INTEGER
		do
			process_replication
			if not current_class.has_flattening_error then
				nb := named_features.count
				create class_features.make_with_capacity (nb)
				current_class.set_features (class_features)
				from named_features.finish until named_features.before loop
					a_feature := named_features.item_for_iteration
					a_feature := flattened_feature (a_feature)
					class_features.put_first (a_feature)
					named_features.back
				end
				nb := new_features_count
				new_features_count := 0
				named_features.wipe_out
				from i := 1 until i > nb loop
					a_feature := class_features.item (i)
						-- Resolve identifier types in signature
						-- of features written in `current_class'.
						-- Those features inherited without being
						-- redeclared in `current_class' have already
						-- had their signature resolved when processing
						-- the parents of `current_class'.
					resolve_identifier_type_signature (a_feature.flattened_feature)
					i := i + 1
				end
				check_anchored_signatures
				nb := class_features.count
				from i := 1 until i > nb loop
					a_feature := class_features.item (i)
					has_qualified_type := False
					check_signature_validity (a_feature)
					if has_qualified_type and not current_class.has_flattening_error then
							-- There is a qualified anchored type in (or reachable
							-- from) the signature of `a_feature'. We will have to
							-- check the signature of this feature again after the
							-- features of the corresponding classes have been
							-- flattened.
							-- Make sure that `class_features' does not contain
							-- inherited features that are also flattened, as
							-- these kind of features are cleaned up before leaving
							-- the feature flattener in `cleanup_inherited_features'.
						if a_feature.is_inherited then
							class_features.put (a_feature.adapted_feature, i)
						else
							-- If the feature is not inherited, then it
							-- is alread flattened (see postcondition of
							-- ET_FEATURE.is_flattened).
						end
					else
						class_features.put (a_feature.flattened_feature, i)
					end
					i := i + 1
				end
			else
				new_features_count := 0
				named_features.wipe_out
			end
		ensure
			named_features_wiped_out: named_features.is_empty
		end

feature {NONE} -- Feature processing

	flattened_feature (a_feature: ET_FEATURE): ET_FEATURE is
			-- Version of `a_feature' after its feature adaptation
			-- has been processed
		require
			a_feature_not_void: a_feature /= Void
		do
			if not a_feature.is_inherited then
				Result := immediate_flattened_feature (a_feature.flattened_feature)
			else
				if a_feature.has_selected_feature and not a_feature.is_selected then
						-- This is not a fatal error for gelint.
					error_handler.report_vmss3_error (current_class, a_feature.selected_feature.inherited_feature)
				end
				if a_feature.is_redeclared then
					Result := redeclared_flattened_feature (a_feature.redeclared_feature)
				else
					Result := inherited_flattened_feature (a_feature)
				end
			end
		ensure
			flattened_feature_not_void: Result /= Void
		end

	immediate_flattened_feature (a_feature: ET_FLATTENED_FEATURE): ET_FEATURE is
			-- Version of `a_feature' after its feature adaptation
			-- has been processed; `a_feature' has been introduced
			-- in `current_class' (ETL2, p. 56).
		require
			a_feature_not_void: a_feature /= Void
		do
			Result := a_feature
		ensure
			flattened_feature_not_void: Result /= Void
		end

	redeclared_flattened_feature (a_feature: ET_REDECLARED_FEATURE): ET_FEATURE is
			-- Version of `a_feature' after its feature adaptation
			-- has been processed; `a_feature' is an inherited feature
			-- which has been given a new declaration in `current_class'.
		require
			a_feature_not_void: a_feature /= Void
		local
			l_flattened_feature: ET_FLATTENED_FEATURE
			l_inherited_feature: ET_FEATURE
			l_has_redefine: BOOLEAN
		do
			l_flattened_feature := a_feature.flattened_feature
			if a_feature.is_replicated then
				process_replicated_seeds (a_feature, l_flattened_feature.id)
			end
			l_flattened_feature.set_first_seed (a_feature.first_seed)
			l_flattened_feature.set_other_seeds (a_feature.other_seeds)
				-- Check Feature_adaptation clause.
			from
				l_inherited_feature := a_feature.parent_feature
			until
				l_inherited_feature = Void
			loop
				if l_inherited_feature.has_redefine then
					if l_has_redefine then
						-- Warning: feature redefined twice.
						-- Could not find which validity rule was violated
						-- and none of the Eiffel compilers complains...
					end
					l_has_redefine := True
				end
				l_inherited_feature := l_inherited_feature.merged_feature
			end
			from
				l_inherited_feature := a_feature.parent_feature
			until
				l_inherited_feature = Void
			loop
				check_redeclaration_validity (l_inherited_feature, l_flattened_feature, l_has_redefine)
				l_inherited_feature := l_inherited_feature.merged_feature
			end
			Result := a_feature
		ensure
			flattened_feature_not_void: Result /= Void
		end

	inherited_flattened_feature (a_feature: ET_FEATURE): ET_FEATURE is
			-- Version of `a_feature' after its feature adaptation
			-- has been processed; `a_feature' is an inherited feature
			-- which has not been given a new declaration in `current_class'.
		require
			a_feature_not_void: a_feature /= Void
			a_feature_inherited: a_feature.is_inherited
			no_redeclaration: not a_feature.is_redeclared
		local
			l_flattened_feature: ET_FLATTENED_FEATURE
			l_inherited_feature: ET_FEATURE
			l_effective, l_deferred: ET_FEATURE
			l_named_feature: ET_INHERITED_FEATURE
			l_first_seed: INTEGER
			l_other_seeds: ET_FEATURE_IDS
			l_keep_same_version: BOOLEAN
			l_shared_feature: ET_FEATURE
			l_duplication_needed: BOOLEAN
			l_feature_found: BOOLEAN
			l_duplicated: BOOLEAN
			l_name: ET_FEATURE_NAME
			l_parent: ET_PARENT
			l_clients: ET_CLASS_NAME_LIST
		do
			l_clients := inherited_clients (a_feature)
			l_first_seed := a_feature.first_seed
			l_other_seeds := a_feature.other_seeds
			l_duplication_needed := a_feature.is_replicated
				-- Check Feature_adaptation clause.
			from
				l_shared_feature := a_feature.precursor_feature
				l_inherited_feature := a_feature
			until
				l_inherited_feature = Void
			loop
				check_no_redeclaration_validity (l_inherited_feature)
				if l_inherited_feature.precursor_feature /= l_shared_feature then
					l_duplication_needed := True
				end
				if not l_inherited_feature.is_deferred then
					if l_effective /= Void and then not l_inherited_feature.same_version (l_effective) then
							-- Error: two effective features which are not shared.
						set_fatal_error (current_class)
						error_handler.report_vmfnc_error (current_class, l_effective.inherited_feature, l_inherited_feature.inherited_feature)
					end
					if not l_feature_found then
						l_effective := l_inherited_feature
						if not l_duplication_needed then
								-- Trying to choose one which would avoid duplication.
							if
								not l_effective.has_rename and then
								l_effective.precursor_feature.first_seed = l_first_seed and then
								l_effective.precursor_feature.other_seeds = l_other_seeds and then
								l_effective.parent.actual_parameters = Void and then
								l_effective.precursor_feature.clients.same_class_names (l_clients)
							then
								l_feature_found := True
							end
						end
					end
				end
				l_inherited_feature := l_inherited_feature.merged_feature
			end
			if l_effective /= Void then
				l_inherited_feature := l_effective
				l_keep_same_version := True
			else
				l_keep_same_version := True
				from
					l_inherited_feature := a_feature
				until
					l_inherited_feature = Void
				loop
					if l_deferred /= Void and then not l_inherited_feature.same_version (l_deferred) then
							-- Not sharing.
						l_keep_same_version := False
						l_duplication_needed := True
					end
					if not l_feature_found then
						l_deferred := l_inherited_feature
						if not l_duplication_needed then
								-- Trying to choose one which would avoid duplication.
							if
								not l_deferred.has_rename and then
								not l_deferred.has_undefine and then
								l_deferred.precursor_feature.first_seed = l_first_seed and then
								l_deferred.precursor_feature.other_seeds = l_other_seeds and then
								l_deferred.parent.actual_parameters = Void and then
								l_deferred.precursor_feature.clients.same_class_names (l_clients)
							then
								l_feature_found := True
							end
						end
					end
					l_inherited_feature := l_inherited_feature.merged_feature
				end
				l_inherited_feature := l_deferred
			end
			l_flattened_feature := l_inherited_feature.precursor_feature
			l_name := l_inherited_feature.name
			l_parent := l_inherited_feature.parent
			if l_inherited_feature.has_undefine then
				l_flattened_feature := l_flattened_feature.undefined_feature (l_name)
				l_duplicated := True
			elseif l_duplication_needed or not l_feature_found then
				l_flattened_feature := l_flattened_feature.renamed_feature (l_name)
				l_duplicated := True
			end
			if l_duplicated then
				universe.register_feature (l_flattened_feature)
				if a_feature.is_replicated then
					process_replicated_seeds (a_feature, l_flattened_feature.id)
				elseif l_keep_same_version then
					l_flattened_feature.set_version (l_inherited_feature.version)
				end
				l_flattened_feature.resolve_inherited_signature (l_parent)
				l_flattened_feature.set_clients (l_clients)
				l_flattened_feature.set_first_seed (a_feature.first_seed)
				l_flattened_feature.set_other_seeds (a_feature.other_seeds)
			end
			if a_feature.is_flattened then
					-- Only one feature inherited (i.e. no merge or join).
				if l_duplicated then
					Result := l_flattened_feature
				else
					Result := a_feature
				end
			else
				l_named_feature := a_feature.inherited_feature
				if l_named_feature /= a_feature then
					Result := l_named_feature
				else
					Result := a_feature
				end
				l_named_feature.set_flattened_feature (l_flattened_feature)
				l_named_feature.set_inherited_flattened_feature (l_inherited_feature)
			end
		ensure
			flattened_feature_not_void: Result /= Void
		end

feature {NONE} -- Replication

	replicable_features: DS_HASH_TABLE [ET_REPLICABLE_FEATURE, INTEGER]
			-- Table of potentially replicable features, indexed by seed

	process_replication is
			-- Take care of selected features and replication.
		local
			l_feature: ET_FEATURE
			l_replicable_feature: ET_REPLICABLE_FEATURE
			l_other_seeds: ET_FEATURE_IDS
			l_seed: INTEGER
			i, nb: INTEGER
		do
			from named_features.start until named_features.after loop
				l_feature := named_features.item_for_iteration
				if l_feature.is_inherited then
					l_seed := l_feature.first_seed
					record_replicable_feature (l_feature, l_seed)
					l_other_seeds := l_feature.other_seeds
					if l_other_seeds /= Void then
						nb := l_other_seeds.count
						from i := 1 until i > nb loop
							l_seed := l_other_seeds.item (i)
							record_replicable_feature (l_feature, l_seed)
							i := i + 1
						end
					end
				end
				named_features.forth
			end
			from replicable_features.start until replicable_features.after loop
				l_replicable_feature := replicable_features.item_for_iteration
				if l_replicable_feature.has_replication then
					l_seed := replicable_features.key_for_iteration
					process_replicated_feature (l_replicable_feature.replicated_feature, l_seed)
				elseif l_replicable_feature.selected_count /= 0 then
					-- There is still a chance that this feature was
					-- listed in the Select subclause to resolve a
					-- replication conflict with another seed. Wait
					-- until all possible replications have been processed.
					-- The actual check is done in `flatten_feature'.
				end
				replicable_features.forth
			end
			replicable_features.wipe_out
		end

	record_replicable_feature (a_feature: ET_FEATURE; a_seed: INTEGER) is
			-- Record `a_feature' with seed `a_seed' in `replicable_features'.
		require
			a_feature_not_void: a_feature /= Void
			a_feature_inherited: a_feature.is_inherited
			valid_seed: a_feature.has_seed (a_seed)
		local
			other_feature: ET_FEATURE
			a_replicable_feature: ET_REPLICABLE_FEATURE
			a_replicated_feature: ET_REPLICATED_FEATURE
		do
			replicable_features.search (a_seed)
			if replicable_features.found then
				a_replicable_feature := replicable_features.found_item
				if a_replicable_feature.has_replication then
					a_replicated_feature := a_replicable_feature.replicated_feature
					a_replicated_feature.put_feature (a_feature)
				else
					other_feature := a_replicable_feature.first_feature
					if other_feature.is_inherited then
						create a_replicated_feature.make (other_feature, a_feature)
						replicable_features.replace_found_item (a_replicated_feature)
					else
							-- Should never happen.
						replicable_features.replace_found_item (a_feature)
					end
				end
			else
				replicable_features.force_new (a_feature, a_seed)
			end
		end

	process_replicated_feature (a_feature: ET_REPLICATED_FEATURE; a_seed: INTEGER) is
			-- Process replicated feature `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
		local
			a_replicated_features: DS_LINKED_LIST [ET_FEATURE]
			an_inherited_features: DS_ARRAYED_LIST [ET_INHERITED_FEATURE]
			an_inherited_feature: ET_INHERITED_FEATURE
			a_redeclared_feature: ET_REDECLARED_FEATURE
			a_replicated_feature: ET_FEATURE
			a_name: ET_FEATURE_NAME
		do
			a_replicated_features := a_feature.features
			inspect a_feature.selected_count
			when 0 then
				create an_inherited_features.make (a_replicated_features.count)
				from a_replicated_features.start until a_replicated_features.after loop
					a_replicated_feature := a_replicated_features.item_for_iteration
					a_replicated_feature := a_replicated_feature.seeded_feature (a_seed)
					an_inherited_features.put_last (a_replicated_feature.inherited_feature)
					a_replicated_features.forth
				end
				set_fatal_error (current_class)
				error_handler.report_vmrc2a_error (current_class, an_inherited_features)
			when 1 then
					-- OK.
				from a_replicated_features.start until a_replicated_features.after loop
					a_replicated_feature := a_replicated_features.item_for_iteration
					if a_replicated_feature.is_redeclared then
						a_redeclared_feature := a_replicated_feature.redeclared_feature
						if not a_redeclared_feature.has_selected_feature then
							a_redeclared_feature.set_replicated (a_seed)
						else
							a_redeclared_feature.set_selected
						end
					else
							-- Get the latest version of `a_replicated_feature'
							-- from `named_features' in case we already updated it.
						a_name := a_replicated_feature.name
						a_replicated_feature := named_features.item (a_name)
						an_inherited_feature := a_replicated_feature.inherited_feature
						if an_inherited_feature /= a_replicated_feature then
							named_features.replace (an_inherited_feature, a_name)
						end
						if not an_inherited_feature.has_selected_feature then
							an_inherited_feature.set_replicated (a_seed)
						else
							an_inherited_feature.set_selected
						end
					end
					a_replicated_features.forth
				end
			else
				create an_inherited_features.make (a_replicated_features.count)
				from a_replicated_features.start until a_replicated_features.after loop
					a_replicated_feature := a_replicated_features.item_for_iteration
					if a_replicated_feature.has_selected_feature then
						if a_replicated_feature.is_redeclared then
							a_redeclared_feature := a_replicated_feature.redeclared_feature
							a_redeclared_feature.set_selected
							a_replicated_feature := a_redeclared_feature.selected_feature
						else
								-- Get the latest version of `a_replicated_feature'
								-- from `named_features' in case we already updated it.
							a_name := a_replicated_feature.name
							a_replicated_feature := named_features.item (a_name)
							an_inherited_feature := a_replicated_feature.inherited_feature
							if an_inherited_feature /= a_replicated_feature then
								named_features.replace (an_inherited_feature, a_name)
							end
							an_inherited_feature.set_selected
							a_replicated_feature := an_inherited_feature.selected_feature
						end
						an_inherited_features.put_last (a_replicated_feature.inherited_feature)
					end
					a_replicated_features.forth
				end
				set_fatal_error (current_class)
				error_handler.report_vmrc2b_error (current_class, an_inherited_features)
			end
		end

	process_replicated_seeds (a_feature: ET_FEATURE; a_new_seed: INTEGER) is
			-- Process the seeds of replicated feature `a_feature'.
			-- Remove seeds in `a_feature.replicated_seeds' and
			-- add `a_new_seed'.
		require
			a_feature_not_void: a_feature /= Void
			inherited_feature: a_feature.is_inherited
			replicated_feature: a_feature.is_replicated
			a_new_seed_positive: a_new_seed > 0
		local
			i, nb: INTEGER
			l_need_twin: BOOLEAN
			l_seed: INTEGER
			l_first_seed: INTEGER
			l_other_seeds: ET_FEATURE_IDS
			l_replicated_seeds: ET_FEATURE_IDS
			l_seeds_done: BOOLEAN
		do
				-- Remove replicated seeds and add the new seed.
			l_first_seed := a_feature.first_seed
			l_other_seeds := a_feature.other_seeds
			check
					-- See postcondition of `is_replicated' in
					-- class ET_FEATURE.
				is_replicated: a_feature.replicated_seeds /= Void
			end
			l_replicated_seeds := a_feature.replicated_seeds
			nb := l_replicated_seeds.count
			if l_other_seeds /= Void then
				if l_replicated_seeds.has (l_first_seed) then
					if nb = 1 then
							-- There was only the first seed to be removed.
						l_seeds_done := True
					elseif nb = l_other_seeds.count + 1 then
							-- All the seeds (first and others) needed
							-- to be removed.
						l_other_seeds := Void
						l_seeds_done := True
					else
							-- There are still seeds to be removed from
							-- `l_other_seeds'. We already took care of
							-- `l_first_seed'.
						l_replicated_seeds.remove (l_first_seed)
						nb := nb - 1
					end
					l_first_seed := a_new_seed
				elseif nb = l_other_seeds.count then
						-- All other seeds need to be removed.
					create l_other_seeds.make (a_new_seed)
					l_seeds_done := True
				end
				if not l_seeds_done then
					l_need_twin := a_feature.is_other_seeds_shared
					if l_need_twin then
						l_other_seeds := clone (l_other_seeds)
					end
					i := 1
					if l_first_seed /= a_new_seed then
							-- The new seed has not been added yet.
							-- Do it now.
						l_other_seeds.replace (l_replicated_seeds.first, a_new_seed)
						i := i + 1
					end
						-- Remove the remaining seeds listed in
						-- `l_replicated_seeds'. Thanks to the test
						-- made a few lines above (those which set
						-- or not `l_seeds_done'), we know that we
						-- will not completely empty `l_other_seeds'.
					from until i > nb loop
						l_seed := l_replicated_seeds.item (i)
						l_other_seeds.remove (l_seed)
						i := i + 1
					end
				end
			else
					-- There was only one seed. So this is the
					-- one to be replace by the new seed.
				l_first_seed := a_new_seed
			end
			a_feature.set_first_seed (l_first_seed)
			a_feature.set_other_seeds (l_other_seeds)
		end

feature {NONE} -- Clients

	clients_list: DS_ARRAYED_LIST [ET_CLASS_NAME_LIST]
			-- List of client clauses

	client_names: DS_HASH_SET [ET_CLASS_NAME]
			-- Client class names

	inherited_clients (a_feature: ET_FEATURE): ET_CLASS_NAME_LIST is
			-- Clients inherited by the not redeclared feature `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
			a_feature_inherited: a_feature.is_inherited
			no_redeclaration: not a_feature.is_redeclared
		local
			l_inherited_feature: ET_FEATURE
			l_clients: ET_CLASS_NAME_LIST
			l_parent: ET_PARENT
			l_exports: ET_EXPORT_LIST
			l_export: ET_EXPORT
			l_name: ET_FEATURE_NAME
			l_overridden: BOOLEAN
			i, nb: INTEGER
			j, nb2: INTEGER
		do
			from
				l_inherited_feature := a_feature
			until
				l_inherited_feature = Void
			loop
				l_overridden := False
				l_name := l_inherited_feature.name
				l_parent := l_inherited_feature.parent
				l_exports := l_parent.exports
				if l_exports /= Void then
					nb := l_exports.count
					from i := 1 until i > nb loop
						l_export := l_exports.item (i)
						if l_export.has_feature_name (l_name) then
							clients_list.force_last (l_export.clients (l_name))
							l_overridden := True
						end
						i := i + 1
					end
				end
				if not l_overridden then
					clients_list.force_last (l_inherited_feature.precursor_feature.clients)
				end
				l_inherited_feature := l_inherited_feature.merged_feature
			end
			Result := clients_list.first
			nb := clients_list.count
			from i := 1 until i > nb loop
				l_clients := clients_list.item (i)
				if l_clients.is_none then
					clients_list.remove (i)
					nb := nb - 1
				else
					nb2 := l_clients.count
					from j := 1 until j > nb2 loop
						client_names.force (l_clients.class_name (j))
						j := j + 1
					end
					i := i + 1
				end
			end
			if clients_list.is_empty then
				-- Keep `Result'.
			elseif clients_list.count = 1 then
				Result := clients_list.first
			else
				Result := Void
				nb2 := client_names.count
				nb := clients_list.count
				from i := 1 until i > nb loop
					l_clients := clients_list.item (i)
					if l_clients.count >= nb2 then
						Result := l_clients
						i := nb + 1 -- Jump out of the loop.
					else
						i := i + 1
					end
				end
				if Result /= Void then
					from client_names.start until client_names.after loop
						if not Result.has (client_names.item_for_iteration) then
							Result := Void
							client_names.go_after -- Jump out of the loop.
						else
							client_names.forth
						end
					end
				end
				if Result = Void then
					create Result.make_with_capacity (nb2)
					from client_names.finish until client_names.before loop
						Result.put_first (client_names.item_for_iteration)
						client_names.back
					end
				end
			end
			client_names.wipe_out
			clients_list.wipe_out
		end

feature {NONE} -- Feature adaptation validity

	check_redeclaration_validity (an_inherited_feature: ET_FEATURE;
		a_redeclared_feature: ET_FLATTENED_FEATURE; has_redefine: BOOLEAN) is
			-- Check validity when `an_inherited_feature' has been
			-- given a new declaration `a_redeclared_feature' in
			-- `current_class'. `has_redefine' indicates whether the
			-- feature has been listed in one of the Redefine clauses
			-- or not.
		require
			an_inherited_feature_not_void: an_inherited_feature /= Void
			an_inherited_feature_inherited: an_inherited_feature.is_inherited
			an_inherited_feature_not_redeclared: not an_inherited_feature.is_redeclared
			a_redeclared_feature_not_void: a_redeclared_feature /= Void
		do
			check_rename_clause_validity (an_inherited_feature)
			check_undefine_clause_validity (an_inherited_feature)
			check_redefine_clause_validity (an_inherited_feature)
			if an_inherited_feature.has_redefine then
				if a_redeclared_feature.is_deferred /= an_inherited_feature.is_deferred then
					if a_redeclared_feature.is_deferred then
							-- Error: Used 'redefine' instead of 'undefine'.
							-- Need to use 'undefine' to redeclare an
							-- effective feature to a deferred feature.
							-- (Not considered as a fatal error by gelint.)
						error_handler.report_vdrd5_error (current_class, an_inherited_feature.inherited_feature, a_redeclared_feature)
					else
							-- Error: No need to 'redefine' to redeclare
							-- a deferred feature to an effective feature.
							-- (Not considered as a fatal error by gelint.)
						error_handler.report_vdrs4b_error (current_class, an_inherited_feature.inherited_feature, a_redeclared_feature)
					end
				end
			elseif a_redeclared_feature.is_deferred then
				if an_inherited_feature.is_deferred then
					if not has_redefine then
							-- Error: Need 'redefine' to redeclare a
							-- deferred feature to a deferred feature.
							-- (Not considered as a fatal error by gelint.)
						error_handler.report_vdrd4a_error (current_class, an_inherited_feature.inherited_feature, a_redeclared_feature)
					end
				else
						-- Error: need 'undefine' and 'redefine' to
						-- redeclare an effective feature to a deferred
						-- feature.
					set_fatal_error (current_class)
					error_handler.report_vmfnb_error (current_class, an_inherited_feature.inherited_feature, a_redeclared_feature)
					error_handler.report_vdrd4c_error (current_class, an_inherited_feature.inherited_feature, a_redeclared_feature)
				end
			elseif not an_inherited_feature.is_deferred then
					-- Error: need 'redefine' to redeclare an effective
					-- feature to an effective feature.
				set_fatal_error (current_class)
				error_handler.report_vmfnb_error (current_class, an_inherited_feature.inherited_feature, a_redeclared_feature)
				error_handler.report_vdrd4b_error (current_class, an_inherited_feature.inherited_feature, a_redeclared_feature)
			end
		end

	check_no_redeclaration_validity (a_feature: ET_FEATURE) is
			-- Check validity when `a_feature' has not been given a new
			-- declaration in `current_class'.
		require
			a_feature_not_void: a_feature /= Void
			a_feature_inherited: a_feature.is_inherited
			a_feature_not_redeclared: not a_feature.is_redeclared
		do
			check_rename_clause_validity (a_feature)
			check_undefine_clause_validity (a_feature)
			check_redefine_clause_validity (a_feature)
			if a_feature.has_redefine then
					-- Error: Not a redefinition.
				set_fatal_error (current_class)
				error_handler.report_vdrs4a_error (current_class, a_feature.inherited_feature)
			end
		end

	check_rename_clause_validity (a_feature: ET_FEATURE) is
			-- Check validity of rename clause for `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
			a_feature_inherited: a_feature.is_inherited
			a_feature_not_redeclared: not a_feature.is_redeclared
		local
			l_inherited_feature: ET_FEATURE
			l_name: ET_FEATURE_NAME
		do
			if a_feature.has_rename then
				l_inherited_feature := a_feature.precursor_feature
				l_name := a_feature.new_name.new_name
				if l_name.is_infix then
					if not l_inherited_feature.is_infixable then
						set_fatal_error (current_class)
						error_handler.report_vhrc5_error (current_class, a_feature.parent, a_feature.new_name, l_inherited_feature)
					end
				elseif l_name.is_prefix then
					if not l_inherited_feature.is_prefixable then
						set_fatal_error (current_class)
						error_handler.report_vhrc4_error (current_class, a_feature.parent, a_feature.new_name, l_inherited_feature)
					end
				end
			end
		end

	check_undefine_clause_validity (a_feature: ET_FEATURE) is
			-- Check validity of undefine clause for `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
			a_feature_inherited: a_feature.is_inherited
			a_feature_not_redeclared: not a_feature.is_redeclared
		local
			l_inherited_feature: ET_FEATURE
		do
			if a_feature.has_undefine then
				l_inherited_feature := a_feature.precursor_feature
				if l_inherited_feature.is_deferred then
						-- This is not a fatal error for gelint.
					error_handler.report_vdus3_error (current_class, a_feature.parent, a_feature.undefine_name)
				end
				if l_inherited_feature.is_frozen then
					set_fatal_error (current_class)
					error_handler.report_vdus2a_error (current_class, a_feature.parent, a_feature.undefine_name)
				end
				if
					l_inherited_feature.is_attribute or
					l_inherited_feature.is_unique_attribute or
					l_inherited_feature.is_constant_attribute
				then
					set_fatal_error (current_class)
					error_handler.report_vdus2b_error (current_class, a_feature.parent, a_feature.undefine_name)
				end
			end
		end

	check_redefine_clause_validity (a_feature: ET_FEATURE) is
			-- Check validity of redefine clause for `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
			a_feature_inherited: a_feature.is_inherited
			a_feature_not_redeclared: not a_feature.is_redeclared
		local
			l_inherited_feature: ET_FEATURE
		do
			if a_feature.has_redefine then
				l_inherited_feature := a_feature.precursor_feature
				if l_inherited_feature.is_frozen then
					set_fatal_error (current_class)
					error_handler.report_vdrs2a_error (current_class, a_feature.parent, a_feature.redefine_name)
				end
				if
					l_inherited_feature.is_unique_attribute or
					l_inherited_feature.is_constant_attribute
				then
					set_fatal_error (current_class)
					error_handler.report_vdrs2b_error (current_class, a_feature.parent, a_feature.redefine_name)
				end
			end
		end

feature {NONE} -- Signature resolving

	resolve_identifier_type_signature (a_feature: ET_FLATTENED_FEATURE) is
			-- Resolve identifier types (e.g. "like identifier"
			-- or "BIT identifier") in signature of `a_feature'
			-- in `current_class'. Do not try to resolve qualified
			-- anchored types other than those of the form
			-- 'like Current.b'. This is done after the features
			-- of the corresponding classes have been flattened.
		require
			a_feature_not_void: a_feature /= Void
			a_feature_registered: a_feature.is_registered
		local
			a_type: ET_TYPE
			args: ET_FORMAL_ARGUMENT_LIST
			an_arg: ET_FORMAL_ARGUMENT
			i, nb: INTEGER
		do
			identifier_type_resolver.set_current_feature (a_feature)
			a_type := a_feature.type
			if a_type /= Void then
				identifier_type_resolver.resolve_type (a_type)
			end
			args := a_feature.arguments
			if args /= Void then
				nb := args.count
				from i := 1 until i > nb loop
					an_arg := args.formal_argument (i)
					identifier_type_resolver.resolve_type (an_arg.type)
					i := i + 1
				end
			end
			identifier_type_resolver.set_current_feature (Void)
		end

	identifier_type_resolver: ET_IDENTIFIER_TYPE_RESOLVER
			-- Identifier type resolver

feature {NONE} -- Signature validity

	check_anchored_signatures is
			-- Check whether there is no cycle in the anchored types
			-- held in the types of all signatures of `current_class'.
			-- Do not try to follow qualified anchored types other
			-- than those of the form 'like Current.b'. This is done
			-- after the features of the corresponding classes have
			-- been flattened.
		do
			anchored_type_checker.check_signatures
		end

	anchored_type_checker: ET_ANCHORED_TYPE_CHECKER
			-- Anchored type checker

	check_signature_validity (a_feature: ET_FEATURE) is
			-- Check signature validity for redeclarations and joinings.
		require
			a_feature_not_void: a_feature /= Void
		local
			a_flattened_feature: ET_FLATTENED_FEATURE
			an_inherited_flattened_feature: ET_FEATURE
			a_redeclared_feature: ET_REDECLARED_FEATURE
			an_inherited_feature: ET_FEATURE
		do
			if a_feature.is_redeclared then
					-- Redeclaration.
				a_redeclared_feature := a_feature.redeclared_feature
				a_flattened_feature := a_feature.flattened_feature
				from
					an_inherited_feature := a_redeclared_feature.parent_feature
				until
					an_inherited_feature = Void
				loop
					check_redeclared_signature_validity (a_flattened_feature, an_inherited_feature)
					an_inherited_feature := an_inherited_feature.merged_feature
				end
			elseif a_feature.is_inherited then
				if a_feature.is_flattened then
					-- Nothing to check. The feature has been inherited with
					-- no joining nor merging, and it has not been redeclared.
				else
					a_flattened_feature := a_feature.flattened_feature
					an_inherited_flattened_feature := a_feature.inherited_feature.inherited_flattened_feature
					if a_flattened_feature.is_deferred then
							-- Joining (merging deferred features together).
						from
							an_inherited_feature := a_feature
						until
							an_inherited_feature = Void
						loop
							if not an_inherited_feature.same_version (an_inherited_flattened_feature.precursor_feature) then
								check_joined_signature_validity (an_inherited_flattened_feature, an_inherited_feature)
							end
							an_inherited_feature := an_inherited_feature.merged_feature
						end
					else
							-- Redeclaration (merging deferred features into
							-- an effective one).
						from
							an_inherited_feature := a_feature
						until
							an_inherited_feature = Void
						loop
							if an_inherited_feature.is_deferred then
								check_merged_signature_validity (a_feature, an_inherited_feature)
							end
							an_inherited_feature := an_inherited_feature.merged_feature
						end
					end
				end
			end
		end

	check_redeclared_signature_validity (a_feature: ET_FLATTENED_FEATURE; other: ET_FEATURE) is
			-- Check whether the signature of `a_feature' conforms
			-- to the signature of `other'. This check has to be done
			-- when `a_feature' is a redeclaration in `current_class'
			-- of the inherited feature `other'.
		require
			a_feature_not_void: a_feature /= Void
			other_not_void: other /= Void
			other_inherited: other.is_inherited
			other_not_redeclared: not other.is_redeclared
		local
			a_type: ET_TYPE
			other_type: ET_TYPE
			other_precursor: ET_FLATTENED_FEATURE
			an_arguments: ET_FORMAL_ARGUMENT_LIST
			other_arguments: ET_FORMAL_ARGUMENT_LIST
			a_resolver: ET_AST_PROCESSOR
			i, nb: INTEGER
		do
				-- We don't want the qualified anchored types in signatures to be resolved yet.
			a_resolver := universe.qualified_signature_resolver
			universe.set_qualified_signature_resolver (universe.null_processor)
			a_type := a_feature.type
			parent_context.set (other.parent.type, current_class)
			other_precursor := other.precursor_feature
			other_type := other_precursor.type
			if a_type = Void then
				if other_type /= Void then
					set_fatal_error (current_class)
					error_handler.report_vdrd2a_error (current_class, a_feature, other.inherited_feature, universe)
				end
			elseif other_type = Void then
				set_fatal_error (current_class)
				error_handler.report_vdrd2a_error (current_class, a_feature, other.inherited_feature, universe)
			elseif not a_type.conforms_to_type (other_type, parent_context, current_class, universe) then
				if
					a_type.has_qualified_type (current_class, universe) or
					other_type.has_qualified_type (parent_context, universe)
				then
						-- We have to delay until qualified
						-- anchored types have been resolved.
					has_qualified_type := True
				else
					set_fatal_error (current_class)
					error_handler.report_vdrd2a_error (current_class, a_feature, other.inherited_feature, universe)
				end
			end
			an_arguments := a_feature.arguments
			other_arguments := other_precursor.arguments
			if an_arguments = Void then
				if other_arguments /= Void then
					set_fatal_error (current_class)
					error_handler.report_vdrd2a_error (current_class, a_feature, other.inherited_feature, universe)
				end
			elseif other_arguments = Void then
				set_fatal_error (current_class)
				error_handler.report_vdrd2a_error (current_class, a_feature, other.inherited_feature, universe)
			else
				nb := an_arguments.count
				if other_arguments.count /= nb then
					set_fatal_error (current_class)
					error_handler.report_vdrd2a_error (current_class, a_feature, other.inherited_feature, universe)
				else
					from i := 1 until i > nb loop
						a_type := an_arguments.formal_argument (i).type
						other_type := other_arguments.formal_argument (i).type
						if not a_type.conforms_to_type (other_type, parent_context, current_class, universe) then
							if
								a_type.has_qualified_type (current_class, universe) or
								other_type.has_qualified_type (parent_context, universe)
							then
									-- We have to delay until qualified
									-- anchored types have been resolved.
								has_qualified_type := True
							else
								set_fatal_error (current_class)
								error_handler.report_vdrd2a_error (current_class, a_feature, other.inherited_feature, universe)
							end
						end
						i := i + 1
					end
				end
			end
			universe.set_qualified_signature_resolver (a_resolver)
		end

	check_merged_signature_validity (a_feature, other: ET_FEATURE) is
			-- Check whether the signature of `a_feature' conforms
			-- to the signature of `other'. This check has to be done
			-- when the inherited deferred feature `other' is merged
			-- to the other inherted feature `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
			a_feature_inherited: a_feature.is_inherited
			a_feature_flattened: not a_feature.is_redeclared
			other_not_void: other /= Void
			other_inherited: other.is_inherited
			other_not_redeclared: not other.is_redeclared
			other_deferred: other.is_deferred
		local
			a_type: ET_TYPE
			other_type: ET_TYPE
			a_flattened_feature: ET_FLATTENED_FEATURE
			an_inherited_feature: ET_INHERITED_FEATURE
			other_precursor: ET_FLATTENED_FEATURE
			an_arguments: ET_FORMAL_ARGUMENT_LIST
			other_arguments: ET_FORMAL_ARGUMENT_LIST
			a_resolver: ET_AST_PROCESSOR
			i, nb: INTEGER
		do
				-- We don't want the qualified anchored types in signatures to be resolved yet.
			a_resolver := universe.qualified_signature_resolver
			universe.set_qualified_signature_resolver (universe.null_processor)
			a_flattened_feature := a_feature.flattened_feature
			a_type := a_flattened_feature.type
			parent_context.set (other.parent.type, current_class)
			other_precursor := other.precursor_feature
			other_type := other_precursor.type
			if a_type = Void then
				if other_type /= Void then
					set_fatal_error (current_class)
					an_inherited_feature := a_feature.inherited_feature.inherited_flattened_feature.inherited_feature
					error_handler.report_vdrd2b_error (current_class, an_inherited_feature, other.inherited_feature, universe)
				end
			elseif other_type = Void then
				set_fatal_error (current_class)
				an_inherited_feature := a_feature.inherited_feature.inherited_flattened_feature.inherited_feature
				error_handler.report_vdrd2b_error (current_class, an_inherited_feature, other.inherited_feature, universe)
			elseif not a_type.conforms_to_type (other_type, parent_context, current_class, universe) then
				if
					a_type.has_qualified_type (current_class, universe) or
					other_type.has_qualified_type (parent_context, universe)
				then
						-- We have to delay until qualified
						-- anchored types have been resolved.
					has_qualified_type := True
				else
					set_fatal_error (current_class)
					an_inherited_feature := a_feature.inherited_feature.inherited_flattened_feature.inherited_feature
					error_handler.report_vdrd2b_error (current_class, an_inherited_feature, other.inherited_feature, universe)
				end
			end
			an_arguments := a_flattened_feature.arguments
			other_arguments := other_precursor.arguments
			if an_arguments = Void then
				if other_arguments /= Void then
					set_fatal_error (current_class)
					an_inherited_feature := a_feature.inherited_feature.inherited_flattened_feature.inherited_feature
					error_handler.report_vdrd2b_error (current_class, an_inherited_feature, other.inherited_feature, universe)
				end
			elseif other_arguments = Void then
				set_fatal_error (current_class)
				an_inherited_feature := a_feature.inherited_feature.inherited_flattened_feature.inherited_feature
				error_handler.report_vdrd2b_error (current_class, an_inherited_feature, other.inherited_feature, universe)
			else
				nb := an_arguments.count
				if other_arguments.count /= nb then
					set_fatal_error (current_class)
					an_inherited_feature := a_feature.inherited_feature.inherited_flattened_feature.inherited_feature
					error_handler.report_vdrd2b_error (current_class, an_inherited_feature, other.inherited_feature, universe)
				else
					from i := 1 until i > nb loop
						a_type := an_arguments.formal_argument (i).type
						other_type := other_arguments.formal_argument (i).type
						if not a_type.conforms_to_type (other_type, parent_context, current_class, universe) then
							if
								a_type.has_qualified_type (current_class, universe) or
								other_type.has_qualified_type (parent_context, universe)
							then
									-- We have to delay until qualified
									-- anchored types have been resolved.
								has_qualified_type := True
							else
								set_fatal_error (current_class)
								an_inherited_feature := a_feature.inherited_feature.inherited_flattened_feature.inherited_feature
								error_handler.report_vdrd2b_error (current_class, an_inherited_feature, other.inherited_feature, universe)
							end
						end
						i := i + 1
					end
				end
			end
			universe.set_qualified_signature_resolver (a_resolver)
		end

	check_joined_signature_validity (a_feature, other: ET_FEATURE) is
			-- Check that `a_feature' and `other' have the same signature
			-- when viewed from `current_class'. This check has to be done
			-- when joining two or more deferred features, the `a_feature'
			-- being the result of the join in `current_class' and `other'
			-- being one of the other deferred features inherited from a
			-- parent of `current_class'. (See ETL2 page 165 about Joining.)
		require
			a_feature_not_void: a_feature /= Void
			a_feature_inherited: a_feature.is_inherited
			a_feature_not_redeclared: not a_feature.is_redeclared
			other_not_void: other /= Void
			other_inherited: other.is_inherited
			other_not_redeclared: not other.is_redeclared
		local
			a_joined_feature: ET_FLATTENED_FEATURE
			other_precursor: ET_FLATTENED_FEATURE
			an_arguments, other_arguments: ET_FORMAL_ARGUMENT_LIST
			a_type, other_type: ET_TYPE
			i, nb: INTEGER
		do
			a_joined_feature := a_feature.flattened_feature
			a_type := a_joined_feature.type
			other_precursor := other.precursor_feature
			other_type := other_precursor.type
			parent_context.set (other.parent.type, current_class)
			if a_type = Void then
				if other_type /= Void then
					set_fatal_error (current_class)
					error_handler.report_vdjr0c_error (current_class, a_feature.inherited_feature, other.inherited_feature)
				end
			elseif other_type = Void then
				set_fatal_error (current_class)
				error_handler.report_vdjr0c_error (current_class, a_feature.inherited_feature, other.inherited_feature)
			elseif not a_type.same_syntactical_type (other_type, parent_context, current_class, universe) then
				if
					a_type.has_qualified_type (current_class, universe) or
					other_type.has_qualified_type (parent_context, universe)
				then
						-- We have to delay until qualified
						-- anchored types have been resolved.
					has_qualified_type := True
				else
					set_fatal_error (current_class)
					error_handler.report_vdjr0c_error (current_class, a_feature.inherited_feature, other.inherited_feature)
				end
			end
			an_arguments := a_joined_feature.arguments
			other_arguments := other_precursor.arguments
			if an_arguments = Void then
				if other_arguments /= Void and then not other_arguments.is_empty then
					set_fatal_error (current_class)
					error_handler.report_vdjr0a_error (current_class, a_feature.inherited_feature, other.inherited_feature)
				end
			elseif other_arguments = Void then
				if not an_arguments.is_empty then
					set_fatal_error (current_class)
					error_handler.report_vdjr0a_error (current_class, a_feature.inherited_feature, other.inherited_feature)
				end
			else
				nb := an_arguments.count
				if other_arguments.count /= nb then
					set_fatal_error (current_class)
					error_handler.report_vdjr0a_error (current_class, a_feature.inherited_feature, other.inherited_feature)
				else
					from i := 1 until i > nb loop
						if not an_arguments.formal_argument (i).type.same_syntactical_type (other_arguments.formal_argument (i).type, parent_context, current_class, universe) then
							if
								a_type.has_qualified_type (current_class, universe) or
								other_type.has_qualified_type (parent_context, universe)
							then
									-- We have to delay until qualified
									-- anchored types have been resolved.
								has_qualified_type := True
							else
								set_fatal_error (current_class)
								error_handler.report_vdjr0b_error (current_class, a_feature.inherited_feature, other.inherited_feature, i)
							end
						end
						i := i + 1
					end
				end
			end
		end

	parent_context: ET_NESTED_TYPE_CONTEXT
			-- Parent context for type conformance checking

	has_qualified_type: BOOLEAN
			-- Is there a qualified anchored type in (or reachable
			-- from) the signature of the feature being analyzed?
			-- If this is the case we will have to check again the
			-- signature of this feature after the features of the
			-- corresponding classes have been flattened.

feature {NONE} -- Formal parameters validity

	check_formal_parameters_validity is
			-- Check validity of formal parameters of `current_class'.
		do
			formal_parameter_checker.check_formal_parameters_validity
		end

	formal_parameter_checker: ET_FORMAL_PARAMETER_CHECKER2
			-- Formal parameter validity checker

feature {NONE} -- Parents validity

	check_parents_validity is
			-- Check validity of parents of `current_class'.
		do
			parent_checker.check_parents_validity
		end

	parent_checker: ET_PARENT_CHECKER2
			-- Parent validity checker

invariant

	named_features_not_void: named_features /= Void
	no_void_named_feature: not named_features.has_item (Void)
	new_features_count_positive: new_features_count >= 0
	new_features_count_small_enough: new_features_count <= named_features.count
	rename_table_not_void: rename_table /= Void
	no_void_rename: not rename_table.has_item (Void)
	no_void_rename_old_name: not rename_table.has (Void)
	undefine_table_not_void: undefine_table /= Void
	no_void_undefine: not undefine_table.has (Void)
	redefine_table_not_void: redefine_table /= Void
	no_void_redefine: not redefine_table.has (Void)
	select_table_not_void: select_table /= Void
	no_void_select: not select_table.has (Void)
	clients_list_not_void: clients_list /= Void
	not_void_clients: not clients_list.has (Void)
	client_names_not_void: client_names /= Void
	no_void_client_name: not client_names.has (Void)
	replicable_features_not_void: replicable_features /= Void
	no_void_replicable_feature: not replicable_features.has_item (Void)
	identifier_type_resolver_not_void: identifier_type_resolver /= Void
	anchored_type_checker_not_void: anchored_type_checker /= Void
	parent_checker_not_void: parent_checker /= Void
	formal_parameter_checker_not_void: formal_parameter_checker /= Void
	parent_context_not_void: parent_context /= Void

end
