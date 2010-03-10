#!/usr/bin/ruby1.9
#
class String
	def new_rule
		"output string"
	end

	def squish_curly_brace
		#if it sees 2 letters in curly braces,
		#	replaces "{HL}" => "F"
		gsub!(/(.*)\{HL\}(.*)/, "F")
		gsub!(/(.*)\{HH\}(.*)/, "H")
		gsub!(/(.*)\{HF\}(.*)/, "F")
		gsub!(/(.*)\{LH\}(.*)/, "L")
		gsub!(/(.*)\{LL\}(.*)/, "L")
		gsub!(/(.*)\{LF\}(.*)/, "L")
		gsub!(/(.*)\{FL\}(.*)/, "F")
		gsub!(/(.*)\{FH\}(.*)/, "F")
		gsub!(/(.*)\{FF\}(.*)/, "F")
		self
	end

	def squish_square_brace
		#if it sees 2 letters in curly braces,
		#	replaces "[HL]" => "F"
		gsub!(/(.*)\[HL\](.*)/, "F")
		gsub!(/(.*)\[HH\](.*)/, "H")
		gsub!(/(.*)\[HF\](.*)/, "F")
		gsub!(/(.*)\[LH\](.*)/, "L")
		gsub!(/(.*)\[LL\](.*)/, "L")
		gsub!(/(.*)\[LF\](.*)/, "L")
		gsub!(/(.*)\[FL\](.*)/, "F")
		gsub!(/(.*)\[FH\](.*)/, "F")
		gsub!(/(.*)\[FF\](.*)/, "F")
		self
	end

	#LHL -> LLH
	#take any string, delete the last term, add an L at the beginning
	def rotate_right_L
		case self
		when /\(.*\)/ then
			gsub!(/(.*)\((.*).\)(.*)/, '\1L\2\3')
		when /\[.*\]/ then
			open_square_bracket_index = index('[')
			close_square_bracket_index = index(']')
			gsub!(/([^\[]*)\[([^\]]*)\](.*)/, '\1\2\3')
			rotate_right_L
			insert(open_square_bracket_index, '[')
			insert(close_square_bracket_index, ']')
		else
			gsub!(/(.*)./, 'L\1')
		end
		self
	end

	#LHFLL => LLHFL
	#if you have an FL, change it to HL
	def FL_HL
		gsub(/(.*)FL(.*)/,'\1HL\2')
	end

	#LLHL => LLHF
	def HL_to_HF
		gsub(/(.*)HL(.*)/,'\1HF\2')
	end

	#[LL] => L
	#[LH] => L
	def squish_LX_L
		gsub(/\[L[LH]\](.*)/, 'L\1')
	end
	#[HH] => H
	#[HL] => F
end

require 'test/unit'

class Test_rules < Test::Unit::TestCase
	def test_rotate_right_L
		assert_equal("LLH", "LHL".rotate_right_L)
	end

	def test_FL_HL
		assert_equal("LLHHL", "LLHFL".FL_HL)
	end

	def test_new_rule
		assert_equal("output string", "input string".new_rule)
	end

	def test_squish_curly_brace_HL_F
		assert_equal("F", "{HL}".squish_curly_brace)
	end

	def test_squish_curly_brace_HH_H
		assert_equal("H", "{HH}".squish_curly_brace)
	end

	def test_squish_curly_brace_HF_F
		assert_equal("F", "{HF}".squish_curly_brace)
	end

	def test_squish_curly_brace_LH_L
		assert_equal("L", "{LH}".squish_curly_brace)
	end

	def test_squish_curly_brace_LL_L
		assert_equal("L", "{LL}".squish_curly_brace)
	end

	def test_squish_curly_brace_LF_L
		assert_equal("L", "{LF}".squish_curly_brace)
	end

	def test_squish_curly_brace_FL_F
		assert_equal("F", "{FL}".squish_curly_brace)
	end

	def test_squish_curly_brace_FH_F
		assert_equal("F", "{FH}".squish_curly_brace)
	end

	def test_squish_curly_brace_FF_F
		assert_equal("F", "{FF}".squish_curly_brace)
	end

	def test_squish_square_brace_HL_F
		assert_equal("F", "[HL]".squish_square_brace)
	end

	def test_squish_square_brace_HH_H
		assert_equal("H", "[HH]".squish_square_brace)
	end

	def test_squish_square_brace_HF_F
		assert_equal("F", "[HF]".squish_square_brace)
	end

	def test_squish_square_brace_LH_L
		assert_equal("L", "[LH]".squish_square_brace)
	end

	def test_squish_square_brace_LL_L
		assert_equal("L", "[LL]".squish_square_brace)
	end

	def test_squish_square_brace_LF_L
		assert_equal("L", "[LF]".squish_square_brace)
	end

	def test_squish_square_brace_FL_F
		assert_equal("F", "[FL]".squish_square_brace)
	end

	def test_squish_square_brace_FH_F
		assert_equal("F", "[FH]".squish_square_brace)
	end

	def test_squish_square_brace_FF_F
		assert_equal("F", "[FF]".squish_square_brace)
	end

	def test_rotate_right_L_with_parens
		assert_equal("HLH", "H(HH)".rotate_right_L)
	end

	def test_rotate_right_L_with_square_brackets
		assert_equal("LL[LF]FH", "LL[FF]HH".rotate_right_L)
	end

	def test_rotate_right_L_with_square_brackets
		assert_equal("[LH][HF]", "[HH][FF]".rotate_right_L)
	end
end
