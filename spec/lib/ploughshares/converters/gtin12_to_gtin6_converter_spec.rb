require "spec_helper"

describe Ploughshares::Converters::GTIN12ToGTIN6Converter do

  subject(:converter) { Ploughshares::Converters::GTIN12ToGTIN6Converter.new(gtin12: gtin12) }

  let(:keyspace_1000_company_code) { "99100" }
  let(:keyspace_100_company_code)  { "99900" }
  let(:keyspace_10_company_code)   { "99990" }
  let(:keyspace_5_company_code)    { "12345" }
  let(:product_code_1000)          { "00999" }
  let(:product_code_100)           { "00099" }
  let(:product_code_10)            { "00004" }
  let(:product_code_5)             { "00009" }
  let(:gtin12_1000)               { "#{keyspace_1000_company_code}#{product_code_1000}" }
  let(:gtin12_100)                { "#{keyspace_100_company_code}#{product_code_100}" }
  let(:gtin12_10)                 { "#{keyspace_10_company_code}#{product_code_10}" }
  let(:gtin12_5)                  { "#{keyspace_5_company_code}#{product_code_5}" }

  context "When company code ends in 000, 100, or 200" do
    let(:gtin12) { gtin12_1000 }

    it "converts 3 digits of the product_code" do
      expect(converter.convert!).to eq "999991"
    end
  end

  context "When company code ends in 300, 400, 500, 600, 700, 800, or 900" do
    let(:gtin12) { gtin12_100 }

    it "converts 2 digits of the product_code and appends the number 3" do
      expect(converter.convert!).to eq "999993"
    end
  end

  context "When company code ends in 00, 10, 20, 30, 40, 50, 60, 70, 80, or 90" do
    let(:gtin12) { gtin12_10 }

    it "converts 1 digit of the product_code and appends the number 4" do
      expect(converter.convert!).to eq "999944"
    end
  end

  context "When company code is anything else" do
    let(:gtin12) { gtin12_5 }

    it "converts 1 digit of the product_code, as long as that digit is >= 5" do
      expect(converter.convert!).to eq "123459"
    end
  end
end
