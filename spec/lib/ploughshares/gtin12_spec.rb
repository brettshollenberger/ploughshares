require "spec_helper"

describe Ploughshares::GTIN12 do
  def valid_gtin_from_ten_digit_string(ten_digit_string)
    base_string = "0#{ten_digit_string}"

    "#{base_string}#{check_digit_for(base_string)}"
  end

  def check_digit_for(base_string)
    unless base_string.length == 11
      raise "Test check digit algorithm may be wrong; expected input of 11 characters-length"
    end

    position_type = :even

    instructions = (0..base_string.length-1).to_a.reverse.map do |index|
      position_type = (position_type == :odd) ? :even : :odd

      {index: index, position_type: position_type}
    end
      
    base_value = instructions.inject(0) do |sum, instruction|
      multiplier = (instruction[:position_type] == :odd) ? 3 : 1

      sum += (base_string[instruction[:index]].to_i * multiplier)
    end  

    next_highest_ten = (base_value*0.1).ceil*10

    next_highest_ten-base_value
  end

  describe "Validity" do
    let(:keyspace_1000_company_code) { "99100" }
    let(:keyspace_100_company_code)  { "99900" }
    let(:keyspace_10_company_code)   { "99990" }
    let(:keyspace_5_company_code)    { "12345" }
    let(:product_code_1000)          { "00999" }
    let(:product_code_100)           { "00099" }
    let(:product_code_10)            { "00004" }
    let(:product_code_5)             { "00009" }
    let(:gtin12_1000)                { "#{keyspace_1000_company_code}#{product_code_1000}" }
    let(:gtin12_100)                 { "#{keyspace_100_company_code}#{product_code_100}" }
    let(:gtin12_10)                  { "#{keyspace_10_company_code}#{product_code_10}" }
    let(:gtin12_5)                   { "#{keyspace_5_company_code}#{product_code_5}" }

    subject(:gtin12) do 
      Ploughshares::GTIN12.new(code: valid_gtin_from_ten_digit_string(sample_input))
    end

    context "With non-numeric characters in input" do
      context "With spaces, hyphens, underscores" do
        let(:sample_input) { gtin12_1000 }

        it "strips these characters before considering validity" do
          expect(gtin12).to be_valid
        end
      end
    end
  end
end
