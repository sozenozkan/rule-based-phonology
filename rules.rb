#!/usr/bin/ruby1.9
#
class String
	def new_rule
		"output string"
	end

	def squish_curly_brace
		#if it sees 2 letters in curly braces,
		#	replaces "{HL}" => "F"
		gsub!(/(.*)\{HL\}(.*)/, '\1F\2')
		gsub!(/(.*)\{HH\}(.*)/, '\1H\2')
		gsub!(/(.*)\{HF\}(.*)/, '\1F\2')
		gsub!(/(.*)\{LH\}(.*)/, '\1L\2')
		gsub!(/(.*)\{LL\}(.*)/, '\1L\2')
		gsub!(/(.*)\{LF\}(.*)/, '\1L\2')
		gsub!(/(.*)\{FL\}(.*)/, '\1F\2')
		gsub!(/(.*)\{FH\}(.*)/, '\1F\2')
		gsub!(/(.*)\{FF\}(.*)/, '\1F\2')
		self
	end

	def squish_square_brace
		#if it sees 2 letters in curly braces,
		#	replaces "[HL]" => "F"
		gsub!(/(.*)\[HL\](.*)/, '\1F\2')
		gsub!(/(.*)\[HH\](.*)/, '\1H\2')
		gsub!(/(.*)\[HF\](.*)/, '\1F\2')
		gsub!(/(.*)\[LH\](.*)/, '\1L\2')
		gsub!(/(.*)\[LL\](.*)/, '\1L\2')
		gsub!(/(.*)\[LF\](.*)/, '\1L\2')
		gsub!(/(.*)\[FL\](.*)/, '\1F\2')
		gsub!(/(.*)\[FH\](.*)/, '\1F\2')
		gsub!(/(.*)\[FF\](.*)/, '\1F\2')
		self
	end

	#LHL -> LLH
	#take any string, delete the last term, add an L at the beginning
	def rotate_right_L
		case self
		when /\(.*\)/ then
			gsub!(/(.*)\((.*).\)(.*)/, '\1L\2\3')
		when /\{.*\}/ then
			open_curly_bracket_index = index('{')
			close_curly_bracket_index = index('}')
			gsub!(/([^\{]*)\{([^\}]*)\}(.*)/, '\1\2\3')
			rotate_right_L
			insert(open_curly_bracket_index, '{')
			insert(close_curly_bracket_index, '}')
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
		while gsub!(/(.*)FL(.*)/,      '\1HL\2'); end
		while gsub!(/(.*)F\{L(.*)/,   '\1H{L\2'); end
		while gsub!(/(.*)F\}L(.*)/,   '\1H}L\2'); end
		while gsub!(/(.*)F\}\{L(.*)/,'\1H}{L\2'); end
		while gsub!(/(.*)F\[L(.*)/,   '\1H[L\2'); end
		while gsub!(/(.*)F\]L(.*)/,   '\1H]L\2'); end
		while gsub!(/(.*)F\]\[L(.*)/,'\1H][L\2'); end
		self
	end

	def F_H_non_ending
		while gsub!(/(.*)F(.+)/,      '\1H\2'); end
		self
	end

	def HL_HF
		while gsub!(/(.*)HL(.*)/,      '\1HF\2'); end
		while gsub!(/(.*)H\{L(.*)/,   '\1H{F\2'); end
		while gsub!(/(.*)H\}L(.*)/,   '\1H}F\2'); end
		while gsub!(/(.*)H\}\{L(.*)/,'\1H}{F\2'); end
		while gsub!(/(.*)H\[L(.*)/,   '\1H[F\2'); end
		while gsub!(/(.*)H\]L(.*)/,   '\1H]F\2'); end
		while gsub!(/(.*)H\]\[L(.*)/,'\1H][F\2'); end
		self
	end
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
		assert_equal("FFF", "F{HL}F".squish_curly_brace)
	end

	def test_squish_curly_brace_HH_H
		assert_equal("FHF", "F{HH}F".squish_curly_brace)
	end

	def test_squish_curly_brace_HF_F
		assert_equal("FFF", "F{HF}F".squish_curly_brace)
	end

	def test_squish_curly_brace_LH_L
		assert_equal("FLF", "F{LH}F".squish_curly_brace)
	end

	def test_squish_curly_brace_LL_L
		assert_equal("FLF", "F{LL}F".squish_curly_brace)
	end

	def test_squish_curly_brace_LF_L
		assert_equal("FLF", "F{LF}F".squish_curly_brace)
	end

	def test_squish_curly_brace_FL_F
		assert_equal("FFF", "F{FL}F".squish_curly_brace)
	end

	def test_squish_curly_brace_FH_F
		assert_equal("FFF", "F{FH}F".squish_curly_brace)
	end

	def test_squish_curly_brace_FF_F
		assert_equal("FFF", "F{FF}F".squish_curly_brace)
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

	def test_FL_HL_with_square_brackets
		assert_equal("FH[LH][LH]LFFH[LH][LH]LF", "FF[LF][LF]LFFF[LF][LF]LF".FL_HL)
	end

	def test_HL_HF_with_square_brackets
		assert_equal("FH[FH][FH]FFFH[FH][FH]FF", "FH[LH][LH]LFFH[LH][LH]LF".HL_HF)
	end

	def test_everything
		File.open("Holoholo Tone Analysis.csv", "r") do |f|
			line_no = 1
			header_line = f.readline
			while line = f.readline do
				line_no += 1
				puts "line #{line_no}"
				forms = line.split(",")
				initial_form = forms.shift.chomp
				output_form = forms.shift.chomp
				puts "initial_form = #{initial_form}"
				transformed = initial_form.squish_curly_brace
				puts "squish_curly_brace = #{transformed}"
				transformed = transformed.rotate_right_L
				puts "rotate_right_L = #{transformed}"
				transformed = transformed.HL_HF
				puts "HL_HF = #{transformed}"
				transformed = transformed.F_H_non_ending
				puts "F_H = #{transformed}"
				transformed = transformed.squish_square_brace
				puts "squish_square_brace = #{transformed}"
				puts
				assert_equal(output_form, transformed)
			end
		end
	rescue EOFError
	end
end
