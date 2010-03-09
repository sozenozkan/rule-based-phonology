#!/usr/bin/ruby1.9
#
class String
	#LHL -> LLH
	#take any string, delete the last term, add an L at the beginning
	def rotate_right_L
		underlying_form = self
		output_form = underlying_form.gsub(/(.*)./, 'L\1')
	end

	#LHFLL => LLHFL
	#if you have an FL, change it to HL
	def FL_to_HL
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

	def test_FL_to_HL
		assert_equal("LLHHL", "LLHFL".FL_to_HL)
	end
end
