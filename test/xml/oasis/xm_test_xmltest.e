indexing

	description:
		
		"Tests from James Clark's xmltest suite from the OASIS xml test suite"

	library: "Gobo Eiffel XML Library test"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "Eiffel Forum License v1 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"
		
deferred class XM_TEST_XMLTEST

inherit

	TS_TEST_CASE
	
	XM_CALLBACKS_FILTER_FACTORY
	
	UC_UNICODE_FACTORY
	
	XMLCONF_XMLTEST_FILES
		export
			{NONE} all
		end
		
feature -- Test
	
	test_extra is
		do
			-- inverted validity as per 		
			--assert_invalid ("xmltest, not well formed, stand alone, 094", xmltest_valid_sa_094)
		end
		
	test_not_wf_sa is
		do

			-- back to normal test
			assert_invalid ("xmltest, not well formed, stand alone, 002", xmltest_not_wf_sa_002)
			assert_invalid ("xmltest, not well formed, stand alone, 003", xmltest_not_wf_sa_003)
			assert_invalid ("xmltest, not well formed, stand alone, 004", xmltest_not_wf_sa_004)
			assert_invalid ("xmltest, not well formed, stand alone, 005", xmltest_not_wf_sa_005)
			assert_invalid ("xmltest, not well formed, stand alone, 006", xmltest_not_wf_sa_006)
			assert_invalid ("xmltest, not well formed, stand alone, 007", xmltest_not_wf_sa_007)
			assert_invalid ("xmltest, not well formed, stand alone, 008", xmltest_not_wf_sa_008)
			assert_invalid ("xmltest, not well formed, stand alone, 009", xmltest_not_wf_sa_009)
			assert_invalid ("xmltest, not well formed, stand alone, 010", xmltest_not_wf_sa_010)
			assert_invalid ("xmltest, not well formed, stand alone, 011", xmltest_not_wf_sa_011)
			assert_invalid ("xmltest, not well formed, stand alone, 012", xmltest_not_wf_sa_012)
			assert_invalid ("xmltest, not well formed, stand alone, 013", xmltest_not_wf_sa_013)
			assert_invalid ("xmltest, not well formed, stand alone, 014", xmltest_not_wf_sa_014)
			assert_invalid ("xmltest, not well formed, stand alone, 015", xmltest_not_wf_sa_015)
			assert_invalid ("xmltest, not well formed, stand alone, 016", xmltest_not_wf_sa_016)
			assert_invalid ("xmltest, not well formed, stand alone, 017", xmltest_not_wf_sa_017)
			assert_invalid ("xmltest, not well formed, stand alone, 018", xmltest_not_wf_sa_018)
			assert_invalid ("xmltest, not well formed, stand alone, 019", xmltest_not_wf_sa_019)
			assert_invalid ("xmltest, not well formed, stand alone, 020", xmltest_not_wf_sa_020)
			assert_invalid ("xmltest, not well formed, stand alone, 021", xmltest_not_wf_sa_021)
			assert_invalid ("xmltest, not well formed, stand alone, 022", xmltest_not_wf_sa_022)
			assert_invalid ("xmltest, not well formed, stand alone, 023", xmltest_not_wf_sa_023)
			assert_invalid ("xmltest, not well formed, stand alone, 024", xmltest_not_wf_sa_024)
			assert_invalid ("xmltest, not well formed, stand alone, 025", xmltest_not_wf_sa_025)
			assert_invalid ("xmltest, not well formed, stand alone, 026", xmltest_not_wf_sa_026)
			assert_invalid ("xmltest, not well formed, stand alone, 027", xmltest_not_wf_sa_027)
			assert_invalid ("xmltest, not well formed, stand alone, 028", xmltest_not_wf_sa_028)
			assert_invalid ("xmltest, not well formed, stand alone, 029", xmltest_not_wf_sa_029)
			assert_invalid ("xmltest, not well formed, stand alone, 030", xmltest_not_wf_sa_030)
			assert_invalid ("xmltest, not well formed, stand alone, 031", xmltest_not_wf_sa_031)
			assert_invalid ("xmltest, not well formed, stand alone, 032", xmltest_not_wf_sa_032)
			assert_invalid ("xmltest, not well formed, stand alone, 033", xmltest_not_wf_sa_033)
			assert_invalid ("xmltest, not well formed, stand alone, 034", xmltest_not_wf_sa_034)
			assert_invalid ("xmltest, not well formed, stand alone, 035", xmltest_not_wf_sa_035)
			assert_invalid ("xmltest, not well formed, stand alone, 036", xmltest_not_wf_sa_036)
			assert_invalid ("xmltest, not well formed, stand alone, 037", xmltest_not_wf_sa_037)
			assert_invalid ("xmltest, not well formed, stand alone, 038", xmltest_not_wf_sa_038)
			assert_invalid ("xmltest, not well formed, stand alone, 039", xmltest_not_wf_sa_039)
			assert_invalid ("xmltest, not well formed, stand alone, 040", xmltest_not_wf_sa_040)
			assert_invalid ("xmltest, not well formed, stand alone, 041", xmltest_not_wf_sa_041)
			assert_invalid ("xmltest, not well formed, stand alone, 042", xmltest_not_wf_sa_042)
			assert_invalid ("xmltest, not well formed, stand alone, 043", xmltest_not_wf_sa_043)
			assert_invalid ("xmltest, not well formed, stand alone, 044", xmltest_not_wf_sa_044)
			assert_invalid ("xmltest, not well formed, stand alone, 045", xmltest_not_wf_sa_045)
			assert_invalid ("xmltest, not well formed, stand alone, 046", xmltest_not_wf_sa_046)
			assert_invalid ("xmltest, not well formed, stand alone, 047", xmltest_not_wf_sa_047)
			assert_invalid ("xmltest, not well formed, stand alone, 048", xmltest_not_wf_sa_048)
			assert_invalid ("xmltest, not well formed, stand alone, 049", xmltest_not_wf_sa_049)
			assert_invalid ("xmltest, not well formed, stand alone, 051", xmltest_not_wf_sa_051)
			assert_invalid ("xmltest, not well formed, stand alone, 052", xmltest_not_wf_sa_052)
			assert_invalid ("xmltest, not well formed, stand alone, 053", xmltest_not_wf_sa_053)
			assert_invalid ("xmltest, not well formed, stand alone, 054", xmltest_not_wf_sa_054)
			assert_invalid ("xmltest, not well formed, stand alone, 055", xmltest_not_wf_sa_055)
			assert_invalid ("xmltest, not well formed, stand alone, 056", xmltest_not_wf_sa_056)
			assert_invalid ("xmltest, not well formed, stand alone, 057", xmltest_not_wf_sa_057)
			assert_invalid ("xmltest, not well formed, stand alone, 058", xmltest_not_wf_sa_058)
			assert_invalid ("xmltest, not well formed, stand alone, 059", xmltest_not_wf_sa_059)
			assert_invalid ("xmltest, not well formed, stand alone, 060", xmltest_not_wf_sa_060)
			assert_invalid ("xmltest, not well formed, stand alone, 061", xmltest_not_wf_sa_061)
			assert_invalid ("xmltest, not well formed, stand alone, 062", xmltest_not_wf_sa_062)
			assert_invalid ("xmltest, not well formed, stand alone, 063", xmltest_not_wf_sa_063)
			assert_invalid ("xmltest, not well formed, stand alone, 064", xmltest_not_wf_sa_064)
			assert_invalid ("xmltest, not well formed, stand alone, 065", xmltest_not_wf_sa_065)
			assert_invalid ("xmltest, not well formed, stand alone, 066", xmltest_not_wf_sa_066)
			assert_invalid ("xmltest, not well formed, stand alone, 067", xmltest_not_wf_sa_067)
			assert_invalid ("xmltest, not well formed, stand alone, 068", xmltest_not_wf_sa_068)
			assert_invalid ("xmltest, not well formed, stand alone, 069", xmltest_not_wf_sa_069)
			assert_invalid ("xmltest, not well formed, stand alone, 070", xmltest_not_wf_sa_070)
			assert_invalid ("xmltest, not well formed, stand alone, 071", xmltest_not_wf_sa_071)
			assert_invalid ("xmltest, not well formed, stand alone, 072", xmltest_not_wf_sa_072)
			assert_invalid ("xmltest, not well formed, stand alone, 073", xmltest_not_wf_sa_073)
			--assert_invalid ("xmltest, not well formed, stand alone, 074", xmltest_not_wf_sa_074)
			assert_invalid ("xmltest, not well formed, stand alone, 075", xmltest_not_wf_sa_075)
			assert_invalid ("xmltest, not well formed, stand alone, 076", xmltest_not_wf_sa_076)
			assert_invalid ("xmltest, not well formed, stand alone, 077", xmltest_not_wf_sa_077)
			assert_invalid ("xmltest, not well formed, stand alone, 078", xmltest_not_wf_sa_078)
			assert_invalid ("xmltest, not well formed, stand alone, 079", xmltest_not_wf_sa_079)
			assert_invalid ("xmltest, not well formed, stand alone, 080", xmltest_not_wf_sa_080)
			assert_invalid ("xmltest, not well formed, stand alone, 081", xmltest_not_wf_sa_081)
			assert_invalid ("xmltest, not well formed, stand alone, 082", xmltest_not_wf_sa_082)
			assert_invalid ("xmltest, not well formed, stand alone, 083", xmltest_not_wf_sa_083)
			assert_invalid ("xmltest, not well formed, stand alone, 084", xmltest_not_wf_sa_084)
			assert_invalid ("xmltest, not well formed, stand alone, 085", xmltest_not_wf_sa_085)
			assert_invalid ("xmltest, not well formed, stand alone, 086", xmltest_not_wf_sa_086)
			assert_invalid ("xmltest, not well formed, stand alone, 087", xmltest_not_wf_sa_087)
			assert_invalid ("xmltest, not well formed, stand alone, 088", xmltest_not_wf_sa_088)
			assert_invalid ("xmltest, not well formed, stand alone, 089", xmltest_not_wf_sa_089)
			assert_invalid ("xmltest, not well formed, stand alone, 090", xmltest_not_wf_sa_090)
			assert_invalid ("xmltest, not well formed, stand alone, 091", xmltest_not_wf_sa_091)
			assert_invalid ("xmltest, not well formed, stand alone, 092", xmltest_not_wf_sa_092)
			assert_invalid ("xmltest, not well formed, stand alone, 093", xmltest_not_wf_sa_093)
			assert_invalid ("xmltest, not well formed, stand alone, 094", xmltest_not_wf_sa_094)
			assert_invalid ("xmltest, not well formed, stand alone, 095", xmltest_not_wf_sa_095)
			assert_invalid ("xmltest, not well formed, stand alone, 096", xmltest_not_wf_sa_096)
			assert_invalid ("xmltest, not well formed, stand alone, 097", xmltest_not_wf_sa_097)
			assert_invalid ("xmltest, not well formed, stand alone, 098", xmltest_not_wf_sa_098)
			assert_invalid ("xmltest, not well formed, stand alone, 099", xmltest_not_wf_sa_099)
			assert_invalid ("xmltest, not well formed, stand alone, 100", xmltest_not_wf_sa_100)
			assert_invalid ("xmltest, not well formed, stand alone, 101", xmltest_not_wf_sa_101)
			assert_invalid ("xmltest, not well formed, stand alone, 102", xmltest_not_wf_sa_102)
			assert_invalid ("xmltest, not well formed, stand alone, 103", xmltest_not_wf_sa_103)
			-- markup in entity
			--assert_invalid ("xmltest, not well formed, stand alone, 104", xmltest_not_wf_sa_104)
			assert_invalid ("xmltest, not well formed, stand alone, 105", xmltest_not_wf_sa_105)
			assert_invalid ("xmltest, not well formed, stand alone, 106", xmltest_not_wf_sa_106)
			assert_invalid ("xmltest, not well formed, stand alone, 107", xmltest_not_wf_sa_107)
			assert_invalid ("xmltest, not well formed, stand alone, 108", xmltest_not_wf_sa_108)
			assert_invalid ("xmltest, not well formed, stand alone, 109", xmltest_not_wf_sa_109)
			assert_invalid ("xmltest, not well formed, stand alone, 110", xmltest_not_wf_sa_110)
			assert_invalid ("xmltest, not well formed, stand alone, 111", xmltest_not_wf_sa_111)
			assert_invalid ("xmltest, not well formed, stand alone, 112", xmltest_not_wf_sa_112)
			assert_invalid ("xmltest, not well formed, stand alone, 113", xmltest_not_wf_sa_113)
			assert_invalid ("xmltest, not well formed, stand alone, 114", xmltest_not_wf_sa_114)
			assert_invalid ("xmltest, not well formed, stand alone, 115", xmltest_not_wf_sa_115)
			assert_invalid ("xmltest, not well formed, stand alone, 116", xmltest_not_wf_sa_116)
			assert_invalid ("xmltest, not well formed, stand alone, 117", xmltest_not_wf_sa_117)
			assert_invalid ("xmltest, not well formed, stand alone, 118", xmltest_not_wf_sa_118)
			assert_invalid ("xmltest, not well formed, stand alone, 119", xmltest_not_wf_sa_119)
			assert_invalid ("xmltest, not well formed, stand alone, 120", xmltest_not_wf_sa_120)
			assert_invalid ("xmltest, not well formed, stand alone, 121", xmltest_not_wf_sa_121)
			assert_invalid ("xmltest, not well formed, stand alone, 122", xmltest_not_wf_sa_122)
			assert_invalid ("xmltest, not well formed, stand alone, 123", xmltest_not_wf_sa_123)
			assert_invalid ("xmltest, not well formed, stand alone, 124", xmltest_not_wf_sa_124)
			assert_invalid ("xmltest, not well formed, stand alone, 125", xmltest_not_wf_sa_125)
			assert_invalid ("xmltest, not well formed, stand alone, 126", xmltest_not_wf_sa_126)
			assert_invalid ("xmltest, not well formed, stand alone, 127", xmltest_not_wf_sa_127)
			assert_invalid ("xmltest, not well formed, stand alone, 128", xmltest_not_wf_sa_128)
			assert_invalid ("xmltest, not well formed, stand alone, 129", xmltest_not_wf_sa_129)
			assert_invalid ("xmltest, not well formed, stand alone, 130", xmltest_not_wf_sa_130)
			assert_invalid ("xmltest, not well formed, stand alone, 131", xmltest_not_wf_sa_131)
			assert_invalid ("xmltest, not well formed, stand alone, 132", xmltest_not_wf_sa_132)
			assert_invalid ("xmltest, not well formed, stand alone, 133", xmltest_not_wf_sa_133)
			assert_invalid ("xmltest, not well formed, stand alone, 134", xmltest_not_wf_sa_134)
			assert_invalid ("xmltest, not well formed, stand alone, 135", xmltest_not_wf_sa_135)
			assert_invalid ("xmltest, not well formed, stand alone, 136", xmltest_not_wf_sa_136)
			assert_invalid ("xmltest, not well formed, stand alone, 137", xmltest_not_wf_sa_137)
			assert_invalid ("xmltest, not well formed, stand alone, 138", xmltest_not_wf_sa_138)
			assert_invalid ("xmltest, not well formed, stand alone, 139", xmltest_not_wf_sa_139)
			-- Unicode, needs pedantic
			--assert_invalid ("xmltest, not well formed, stand alone, 140", xmltest_not_wf_sa_140)
			--assert_invalid ("xmltest, not well formed, stand alone, 141", xmltest_not_wf_sa_141)
			assert_invalid ("xmltest, not well formed, stand alone, 142", xmltest_not_wf_sa_142)
			assert_invalid ("xmltest, not well formed, stand alone, 143", xmltest_not_wf_sa_143)
			assert_invalid ("xmltest, not well formed, stand alone, 144", xmltest_not_wf_sa_144)
			--assert_invalid ("xmltest, not well formed, stand alone, 145", xmltest_not_wf_sa_145)
			--assert_invalid ("xmltest, not well formed, stand alone, 146", xmltest_not_wf_sa_146)
			assert_invalid ("xmltest, not well formed, stand alone, 147", xmltest_not_wf_sa_147)
			assert_invalid ("xmltest, not well formed, stand alone, 148", xmltest_not_wf_sa_148)
			assert_invalid ("xmltest, not well formed, stand alone, 149", xmltest_not_wf_sa_149)
			assert_invalid ("xmltest, not well formed, stand alone, 150", xmltest_not_wf_sa_150)
			assert_invalid ("xmltest, not well formed, stand alone, 151", xmltest_not_wf_sa_151)
			assert_invalid ("xmltest, not well formed, stand alone, 152", xmltest_not_wf_sa_152)
			assert_invalid ("xmltest, not well formed, stand alone, 153", xmltest_not_wf_sa_153)
			assert_invalid ("xmltest, not well formed, stand alone, 154", xmltest_not_wf_sa_154)
			assert_invalid ("xmltest, not well formed, stand alone, 155", xmltest_not_wf_sa_155)
			assert_invalid ("xmltest, not well formed, stand alone, 156", xmltest_not_wf_sa_156)
			assert_invalid ("xmltest, not well formed, stand alone, 157", xmltest_not_wf_sa_157)
			assert_invalid ("xmltest, not well formed, stand alone, 158", xmltest_not_wf_sa_158)
			assert_invalid ("xmltest, not well formed, stand alone, 159", xmltest_not_wf_sa_159)
			assert_invalid ("xmltest, not well formed, stand alone, 160", xmltest_not_wf_sa_160)
			assert_invalid ("xmltest, not well formed, stand alone, 161", xmltest_not_wf_sa_161)
			assert_invalid ("xmltest, not well formed, stand alone, 162", xmltest_not_wf_sa_162)
			assert_invalid ("xmltest, not well formed, stand alone, 163", xmltest_not_wf_sa_163)
			assert_invalid ("xmltest, not well formed, stand alone, 164", xmltest_not_wf_sa_164)
			assert_invalid ("xmltest, not well formed, stand alone, 165", xmltest_not_wf_sa_165)
			-- unicode
			--assert_invalid ("xmltest, not well formed, stand alone, 166", xmltest_not_wf_sa_166)
			--assert_invalid ("xmltest, not well formed, stand alone, 167", xmltest_not_wf_sa_167)
			--assert_invalid ("xmltest, not well formed, stand alone, 168", xmltest_not_wf_sa_168)
			--assert_invalid ("xmltest, not well formed, stand alone, 169", xmltest_not_wf_sa_169)
			--assert_invalid ("xmltest, not well formed, stand alone, 170", xmltest_not_wf_sa_170)
			--assert_invalid ("xmltest, not well formed, stand alone, 171", xmltest_not_wf_sa_171)
			--assert_invalid ("xmltest, not well formed, stand alone, 172", xmltest_not_wf_sa_172)
			--assert_invalid ("xmltest, not well formed, stand alone, 173", xmltest_not_wf_sa_173)
			--assert_invalid ("xmltest, not well formed, stand alone, 174", xmltest_not_wf_sa_174)
			--assert_invalid ("xmltest, not well formed, stand alone, 175", xmltest_not_wf_sa_175)
			assert_invalid ("xmltest, not well formed, stand alone, 176", xmltest_not_wf_sa_176)
			--assert_invalid ("xmltest, not well formed, stand alone, 177", xmltest_not_wf_sa_177)
			assert_invalid ("xmltest, not well formed, stand alone, 178", xmltest_not_wf_sa_178)
			assert_invalid ("xmltest, not well formed, stand alone, 179", xmltest_not_wf_sa_179)
			assert_invalid ("xmltest, not well formed, stand alone, 180", xmltest_not_wf_sa_180)
			assert_invalid ("xmltest, not well formed, stand alone, 181", xmltest_not_wf_sa_181)
			assert_invalid ("xmltest, not well formed, stand alone, 182", xmltest_not_wf_sa_182)
			assert_invalid ("xmltest, not well formed, stand alone, 183", xmltest_not_wf_sa_183)
			assert_invalid ("xmltest, not well formed, stand alone, 184", xmltest_not_wf_sa_184)
			assert_invalid ("xmltest, not well formed, stand alone, 185", xmltest_not_wf_sa_185)
			assert_invalid ("xmltest, not well formed, stand alone, 186", xmltest_not_wf_sa_186)
		end

	test_valid_sa is
			-- Test valid output.
		do
			assert_output ("xmltest, valid, stand alone, 001", xmltest_valid_sa_001, xmltest_valid_sa_out_001)
			assert_output ("xmltest, valid, stand alone, 002", xmltest_valid_sa_002, xmltest_valid_sa_out_002)
			assert_output ("xmltest, valid, stand alone, 003", xmltest_valid_sa_003, xmltest_valid_sa_out_003)
			assert_output ("xmltest, valid, stand alone, 004", xmltest_valid_sa_004, xmltest_valid_sa_out_004)
			assert_output ("xmltest, valid, stand alone, 005", xmltest_valid_sa_005, xmltest_valid_sa_out_005)
			assert_output ("xmltest, valid, stand alone, 006", xmltest_valid_sa_006, xmltest_valid_sa_out_006)
			assert_output ("xmltest, valid, stand alone, 007", xmltest_valid_sa_007, xmltest_valid_sa_out_007)
			-- &quot;
			--assert_output ("xmltest, valid, stand alone, 008", xmltest_valid_sa_008, xmltest_valid_sa_out_008)
			assert_output ("xmltest, valid, stand alone, 009", xmltest_valid_sa_009, xmltest_valid_sa_out_009)
			assert_output ("xmltest, valid, stand alone, 010", xmltest_valid_sa_010, xmltest_valid_sa_out_010)
			assert_output ("xmltest, valid, stand alone, 011", xmltest_valid_sa_011, xmltest_valid_sa_out_011)
			-- : in name
			--assert_output ("xmltest, valid, stand alone, 012", xmltest_valid_sa_012, xmltest_valid_sa_out_012)
			assert_output ("xmltest, valid, stand alone, 013", xmltest_valid_sa_013, xmltest_valid_sa_out_013)
			assert_output ("xmltest, valid, stand alone, 014", xmltest_valid_sa_014, xmltest_valid_sa_out_014)
			assert_output ("xmltest, valid, stand alone, 015", xmltest_valid_sa_015, xmltest_valid_sa_out_015)
			assert_output ("xmltest, valid, stand alone, 016", xmltest_valid_sa_016, xmltest_valid_sa_out_016)
			assert_output ("xmltest, valid, stand alone, 017", xmltest_valid_sa_017, xmltest_valid_sa_out_017)
			assert_output ("xmltest, valid, stand alone, 018", xmltest_valid_sa_018, xmltest_valid_sa_out_018)
			assert_output ("xmltest, valid, stand alone, 019", xmltest_valid_sa_019, xmltest_valid_sa_out_019)
			assert_output ("xmltest, valid, stand alone, 020", xmltest_valid_sa_020, xmltest_valid_sa_out_020)
			assert_output ("xmltest, valid, stand alone, 021", xmltest_valid_sa_021, xmltest_valid_sa_out_021)
			assert_output ("xmltest, valid, stand alone, 022", xmltest_valid_sa_022, xmltest_valid_sa_out_022)
			assert_output ("xmltest, valid, stand alone, 023", xmltest_valid_sa_023, xmltest_valid_sa_out_023)
			assert_output ("xmltest, valid, stand alone, 024", xmltest_valid_sa_024, xmltest_valid_sa_out_024)
			assert_output ("xmltest, valid, stand alone, 025", xmltest_valid_sa_025, xmltest_valid_sa_out_025)
			assert_output ("xmltest, valid, stand alone, 026", xmltest_valid_sa_026, xmltest_valid_sa_out_026)
			assert_output ("xmltest, valid, stand alone, 027", xmltest_valid_sa_027, xmltest_valid_sa_out_027)
			assert_output ("xmltest, valid, stand alone, 028", xmltest_valid_sa_028, xmltest_valid_sa_out_028)
			assert_output ("xmltest, valid, stand alone, 029", xmltest_valid_sa_029, xmltest_valid_sa_out_029)
			assert_output ("xmltest, valid, stand alone, 030", xmltest_valid_sa_030, xmltest_valid_sa_out_030)
			assert_output ("xmltest, valid, stand alone, 031", xmltest_valid_sa_031, xmltest_valid_sa_out_031)
			assert_output ("xmltest, valid, stand alone, 032", xmltest_valid_sa_032, xmltest_valid_sa_out_032)
			assert_output ("xmltest, valid, stand alone, 033", xmltest_valid_sa_033, xmltest_valid_sa_out_033)
			assert_output ("xmltest, valid, stand alone, 034", xmltest_valid_sa_034, xmltest_valid_sa_out_034)
			assert_output ("xmltest, valid, stand alone, 035", xmltest_valid_sa_035, xmltest_valid_sa_out_035)
			assert_output ("xmltest, valid, stand alone, 036", xmltest_valid_sa_036, xmltest_valid_sa_out_036)
			assert_output ("xmltest, valid, stand alone, 037", xmltest_valid_sa_037, xmltest_valid_sa_out_037)
			assert_output ("xmltest, valid, stand alone, 038", xmltest_valid_sa_038, xmltest_valid_sa_out_038)
			assert_output ("xmltest, valid, stand alone, 039", xmltest_valid_sa_039, xmltest_valid_sa_out_039)
			assert_output ("xmltest, valid, stand alone, 040", xmltest_valid_sa_040, xmltest_valid_sa_out_040)
			assert_output ("xmltest, valid, stand alone, 041", xmltest_valid_sa_041, xmltest_valid_sa_out_041)
			assert_output ("xmltest, valid, stand alone, 042", xmltest_valid_sa_042, xmltest_valid_sa_out_042)
			assert_output ("xmltest, valid, stand alone, 043", xmltest_valid_sa_043, xmltest_valid_sa_out_043)
			-- default attributes not resolved
			--assert_output ("xmltest, valid, stand alone, 044", xmltest_valid_sa_044, xmltest_valid_sa_out_044)
			--assert_output ("xmltest, valid, stand alone, 045", xmltest_valid_sa_045, xmltest_valid_sa_out_045)
			--assert_output ("xmltest, valid, stand alone, 046", xmltest_valid_sa_046, xmltest_valid_sa_out_046)
			assert_output ("xmltest, valid, stand alone, 047", xmltest_valid_sa_047, xmltest_valid_sa_out_047)
			assert_output ("xmltest, valid, stand alone, 048", xmltest_valid_sa_048, xmltest_valid_sa_out_048)
			-- unicode, need parse string to use stream
			--assert_output ("xmltest, valid, stand alone, 049", xmltest_valid_sa_049, xmltest_valid_sa_out_049)
			--assert_output ("xmltest, valid, stand alone, 050", xmltest_valid_sa_050, xmltest_valid_sa_out_050)
			--assert_output ("xmltest, valid, stand alone, 051", xmltest_valid_sa_051, xmltest_valid_sa_out_051)
			assert_output ("xmltest, valid, stand alone, 052", xmltest_valid_sa_052, xmltest_valid_sa_out_052)
			assert_output ("xmltest, valid, stand alone, 053", xmltest_valid_sa_053, xmltest_valid_sa_out_053)
			assert_output ("xmltest, valid, stand alone, 054", xmltest_valid_sa_054, xmltest_valid_sa_out_054)
			assert_output ("xmltest, valid, stand alone, 055", xmltest_valid_sa_055, xmltest_valid_sa_out_055)
			assert_output ("xmltest, valid, stand alone, 056", xmltest_valid_sa_056, xmltest_valid_sa_out_056)
			assert_output ("xmltest, valid, stand alone, 057", xmltest_valid_sa_057, xmltest_valid_sa_out_057)
			-- attribute space normalisation
			--assert_output ("xmltest, valid, stand alone, 058", xmltest_valid_sa_058, xmltest_valid_sa_out_058)
			assert_output ("xmltest, valid, stand alone, 059", xmltest_valid_sa_059, xmltest_valid_sa_out_059)
			assert_output ("xmltest, valid, stand alone, 060", xmltest_valid_sa_060, xmltest_valid_sa_out_060)
			assert_output ("xmltest, valid, stand alone, 061", xmltest_valid_sa_061, xmltest_valid_sa_out_061)
			assert_output ("xmltest, valid, stand alone, 062", xmltest_valid_sa_062, xmltest_valid_sa_out_062)
			assert_output ("xmltest, valid, stand alone, 063", xmltest_valid_sa_063, xmltest_valid_sa_out_063)
			assert_output ("xmltest, valid, stand alone, 064", xmltest_valid_sa_064, xmltest_valid_sa_out_064)
			assert_output ("xmltest, valid, stand alone, 065", xmltest_valid_sa_065, xmltest_valid_sa_out_065)
			assert_output ("xmltest, valid, stand alone, 066", xmltest_valid_sa_066, xmltest_valid_sa_out_066)
			assert_output ("xmltest, valid, stand alone, 067", xmltest_valid_sa_067, xmltest_valid_sa_out_067)
			-- normalisation of newline in entity
			--assert_output ("xmltest, valid, stand alone, 068", xmltest_valid_sa_068, xmltest_valid_sa_out_068)
			-- DOCTYPE in output????
			assert_valid ("xmltest, valid, stand alone, 069", xmltest_valid_sa_069)--, xmltest_valid_sa_out_069)
			assert_output ("xmltest, valid, stand alone, 070", xmltest_valid_sa_070, xmltest_valid_sa_out_070)
			assert_output ("xmltest, valid, stand alone, 071", xmltest_valid_sa_071, xmltest_valid_sa_out_071)
			assert_output ("xmltest, valid, stand alone, 072", xmltest_valid_sa_072, xmltest_valid_sa_out_072)
			assert_output ("xmltest, valid, stand alone, 073", xmltest_valid_sa_073, xmltest_valid_sa_out_073)
			assert_output ("xmltest, valid, stand alone, 074", xmltest_valid_sa_074, xmltest_valid_sa_out_074)
			assert_output ("xmltest, valid, stand alone, 075", xmltest_valid_sa_075, xmltest_valid_sa_out_075)
			-- DOCTYPE in output????			
			assert_valid ("xmltest, valid, stand alone, 076", xmltest_valid_sa_076)--, xmltest_valid_sa_out_076)
			assert_output ("xmltest, valid, stand alone, 077", xmltest_valid_sa_077, xmltest_valid_sa_out_077)
			assert_output ("xmltest, valid, stand alone, 078", xmltest_valid_sa_078, xmltest_valid_sa_out_078)
			assert_output ("xmltest, valid, stand alone, 079", xmltest_valid_sa_079, xmltest_valid_sa_out_079)
			-- attribute default fixed
			--assert_output ("xmltest, valid, stand alone, 080", xmltest_valid_sa_080, xmltest_valid_sa_out_080)
			assert_output ("xmltest, valid, stand alone, 081", xmltest_valid_sa_081, xmltest_valid_sa_out_081)
			assert_output ("xmltest, valid, stand alone, 082", xmltest_valid_sa_082, xmltest_valid_sa_out_082)
			assert_output ("xmltest, valid, stand alone, 083", xmltest_valid_sa_083, xmltest_valid_sa_out_083)
			assert_output ("xmltest, valid, stand alone, 084", xmltest_valid_sa_084, xmltest_valid_sa_out_084)
			assert_output ("xmltest, valid, stand alone, 085", xmltest_valid_sa_085, xmltest_valid_sa_out_085)
			assert_output ("xmltest, valid, stand alone, 086", xmltest_valid_sa_086, xmltest_valid_sa_out_086)
			assert_output ("xmltest, valid, stand alone, 087", xmltest_valid_sa_087, xmltest_valid_sa_out_087)
			assert_output ("xmltest, valid, stand alone, 088", xmltest_valid_sa_088, xmltest_valid_sa_out_088)
			assert_output ("xmltest, valid, stand alone, 089", xmltest_valid_sa_089, xmltest_valid_sa_out_089)
			-- DOCTYPE in output????			
			assert_valid ("xmltest, valid, stand alone, 090", xmltest_valid_sa_090)--, xmltest_valid_sa_out_090)
			assert_valid ("xmltest, valid, stand alone, 091", xmltest_valid_sa_091)--, xmltest_valid_sa_out_091)
			-- newline normalisation
			--assert_output ("xmltest, valid, stand alone, 092", xmltest_valid_sa_092, xmltest_valid_sa_out_092)
			--assert_output ("xmltest, valid, stand alone, 093", xmltest_valid_sa_093, xmltest_valid_sa_out_093)
			--assert_output ("xmltest, valid, stand alone, 095", xmltest_valid_sa_095, xmltest_valid_sa_out_095)
			--assert_output ("xmltest, valid, stand alone, 096", xmltest_valid_sa_096, xmltest_valid_sa_out_096)
			-- uses external entity
			--assert_output ("xmltest, valid, stand alone, 097", xmltest_valid_sa_097, xmltest_valid_sa_out_097)
			assert_output ("xmltest, valid, stand alone, 098", xmltest_valid_sa_098, xmltest_valid_sa_out_098)
			assert_output ("xmltest, valid, stand alone, 099", xmltest_valid_sa_099, xmltest_valid_sa_out_099)
			assert_output ("xmltest, valid, stand alone, 100", xmltest_valid_sa_100, xmltest_valid_sa_out_100)
			assert_output ("xmltest, valid, stand alone, 101", xmltest_valid_sa_101, xmltest_valid_sa_out_101)
			assert_output ("xmltest, valid, stand alone, 102", xmltest_valid_sa_102, xmltest_valid_sa_out_102)
			assert_output ("xmltest, valid, stand alone, 103", xmltest_valid_sa_103, xmltest_valid_sa_out_103)
			assert_output ("xmltest, valid, stand alone, 104", xmltest_valid_sa_104, xmltest_valid_sa_out_104)
			assert_output ("xmltest, valid, stand alone, 105", xmltest_valid_sa_105, xmltest_valid_sa_out_105)
			assert_output ("xmltest, valid, stand alone, 106", xmltest_valid_sa_106, xmltest_valid_sa_out_106)
			assert_output ("xmltest, valid, stand alone, 107", xmltest_valid_sa_107, xmltest_valid_sa_out_107)
			assert_output ("xmltest, valid, stand alone, 108", xmltest_valid_sa_108, xmltest_valid_sa_out_108)
			assert_output ("xmltest, valid, stand alone, 109", xmltest_valid_sa_109, xmltest_valid_sa_out_109)
			-- attribute normalisation
			--assert_output ("xmltest, valid, stand alone, 110", xmltest_valid_sa_110, xmltest_valid_sa_out_110)
			--assert_output ("xmltest, valid, stand alone, 111", xmltest_valid_sa_111, xmltest_valid_sa_out_111)
			assert_output ("xmltest, valid, stand alone, 112", xmltest_valid_sa_112, xmltest_valid_sa_out_112)
			assert_output ("xmltest, valid, stand alone, 113", xmltest_valid_sa_113, xmltest_valid_sa_out_113)
			assert_output ("xmltest, valid, stand alone, 114", xmltest_valid_sa_114, xmltest_valid_sa_out_114)
			assert_output ("xmltest, valid, stand alone, 115", xmltest_valid_sa_115, xmltest_valid_sa_out_115)
			-- line break normalisation
			--assert_output ("xmltest, valid, stand alone, 116", xmltest_valid_sa_116, xmltest_valid_sa_out_116)
			assert_output ("xmltest, valid, stand alone, 117", xmltest_valid_sa_117, xmltest_valid_sa_out_117)
			assert_output ("xmltest, valid, stand alone, 118", xmltest_valid_sa_118, xmltest_valid_sa_out_118)
			assert_output ("xmltest, valid, stand alone, 119", xmltest_valid_sa_119, xmltest_valid_sa_out_119)
		end
		
feature -- XML asserts

	assert_valid (a_name: STRING; in: STRING) is
			-- Assert valid.
		require
			name_not_void: a_name /= Void
			in_not_void: in /= Void
		do
			reset_parser
			parser.parse_from_string (in)
			assert (a_name, parser.is_correct)
		end
		
	assert_invalid (a_name: STRING; in: STRING) is
			-- Assert invalid.
		require
			name_not_void: a_name /= Void
			in_not_void: in /= Void
		do
			reset_parser
			parser.parse_from_string (in)
			assert (a_name, not parser.is_correct)
		end
		
	assert_output (a_name: STRING; in: STRING; an_out: STRING) is
			-- Assert valid output.
		require
			name_not_void: a_name /= Void
			in_not_void: in /= Void
			out_not_void: out /= Void
		do
			reset_parser
			parser.parse_from_string (in)

			debug ("xml_parser")
				if not parser.is_correct then 
					io.put_string (parser.last_error_description) 
				end
			end
			assert ("Valid: " + a_name, parser.is_correct)
			assert_equal ("Output: " + a_name, an_out, output.to_utf8)
		end
		
		
feature {NONE} -- Parser
	
	parser: XM_PARSER
			-- Parser.
			
	output: UC_STRING
			-- Output.
			
	new_parser: XM_PARSER is
			-- New parser, can be redefined to test another parser.
		do
			!XM_EIFFEL_PARSER! Result.make
		end
		
	reset_parser is
			-- Reset parser.
		do
			output := new_unicode_string ("")
			parser := new_parser
			parser.set_callbacks (callbacks_pipe (<<  
				new_end_tag_checker,
				new_stop_on_error,
				new_pretty_print_string(output) >>))
		ensure
			not_void: parser /= Void and output /= Void
		end

end

