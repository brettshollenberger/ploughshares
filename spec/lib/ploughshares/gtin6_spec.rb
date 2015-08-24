require "spec_helper"

describe Ploughshares::GTIN6 do
  describe "Compressing GTIN-12s into GTIN-6s" do
    let(:keyspace_1000_company_code) { "99100" }
    let(:keyspace_100_company_code)  { "99900" }
    let(:keyspace_10_company_code)   { "99990" }
    let(:keyspace_5_company_code)    { "12345" }
    let(:product_code_1000)          { "00999" }
    let(:product_code_100)           { "00099" }
    let(:product_code_10)            { "00004" }
    let(:product_code_5)             { "00009" }
    let(:gtin_12_1000)               { "#{keyspace_1000_company_code}#{product_code_1000}" }
    let(:gtin_12_100)                { "#{keyspace_100_company_code}#{product_code_100}" }
    let(:gtin_12_10)                 { "#{keyspace_10_company_code}#{product_code_10}" }
    let(:gtin_12_5)                  { "#{keyspace_5_company_code}#{product_code_5}" }

    it "translates codes for companies ending in 000, 100, or 200" do
      expect(Ploughshares::GTIN6.from(:gtin12, gtin_12_1000).to_s).to eq "999991"
    end

    it "translates codes for companies ending in 300, 400, 500, 600, 700, 800, or 900" do
      expect(Ploughshares::GTIN6.from(:gtin12, gtin_12_100).to_s).to eq "999993"
    end

    it "translates codes for companies ending in 10-90" do
      expect(Ploughshares::GTIN6.from(:gtin12, gtin_12_10).to_s).to eq "999944"
    end

    it "translates all other company codes" do
      expect(Ploughshares::GTIN6.from(:gtin12, gtin_12_5).to_s).to eq "123459"
    end
  end
end
