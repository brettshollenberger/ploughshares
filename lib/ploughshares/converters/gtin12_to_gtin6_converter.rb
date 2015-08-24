# GTIN-12 to GTIN-6 conversion rules:
#
# 1. Manufacturer codes ending in 000, 100, or 200 receive 1,000 UPC-Es each.
#
#   A. The product codes they can compress are 00000 - 00999
#
#   B. The manufacturer uses the 1st 2 (unknown) characters of their manufacturer code, 
#      followed by the last 3 product code digits, plus the 3rd character of 
#      their manufacturer code
#
#   C. E.g. A manufacturer numbered 99100 with a product numbered 00888 would have a 
#      UPC-A of  99100-00888 and a UPC-E of 998881.
#
# 2. Manufacturer codes ending in 00, but not qualified for #1 (e.g. 300-900) receive 100 UPC-Es each.
#     A. The product codes they can compress are 00000 - 00099
#
#     B. The manufacturer uses the 1st 3 characters of their manufacturer code, 
#        followed by the last 2 product code digits, plus the digit 3.
#
#     C. A manufacturer numbered 99300 with a product numbered 00088 
#        would have a UPC-A of 99300-00088, and a UPC-E of 993883. 
#
# 3. Manufacturer codes ending in 0, but not qualified for #2, (e.g. 00-90) 
#    receive 10 UPC-Es each.
#
#     A. The product codes they can compress are 00000 - 00009
#
#     B. They use the first 4 digits for their manufacturer code, 
#        the last character of their product code, plus the digit 4.
#
#     C. A manufacturer numbered 99990 with a product numbered 00001 
#        would have a UPC-A of 99990-00001, and a UPC-E of 999914.
#
# 1. All other manufacturers receive 5 UPC-Es each. 
#
#     A. The product codes they can compress are 00005 - 00009
#
#     B. They use their entire manufacturer code followed by the last 
#        character of their product code
#
#     C. A manufacturer numbered 99999 with a product numbered 00005 would 
#        have a UPC-A of 99999-00005, and a UPC-E of 999995.
# 
module Ploughshares
  module Converters
    class GTIN12ToGTIN6Converter
      class InputNotConvertibleToGTIN12Error < StandardError; end

      attr_accessor :gtin12

      def initialize(options = {})
        raise "Option :gtin12 is required in GTIN12ToGTIN6Converter" if options[:gtin12].nil?

        gtin12 = options[:gtin12]

        if gtin12.is_a?(GTIN12)
          # nothing to do
        elsif gtin12.respond_to?(:convertible_to_gtin12?) && gtin12.convertible_to_gtin12?
          gtin12 = gtin12.convert_to_gtin12!
        elsif gtin12.respond_to?(:to_s)
          gtin12 = GTIN12.new(code: gtin12.to_s)
        end

        unless gtin12.valid?
          raise InputNotConvertibleToGTIN12Error, options[:gtin12]
        end

        @gtin12 = gtin12
      end

      def gtin12s_company_code
        gtin12.company_code
      end

      def gtin12s_product_code
        gtin12.product_code
      end

      def convert!
        case gtin12s_company_code
        when codes_000_100_200
          "#{gtin12s_company_code[0..1]}#{gtin12s_product_code[-3..-1]}#{gtin12s_company_code[2]}"
        when codes_300_400_500_600_700_800_900
          "#{gtin12s_company_code[0..2]}#{gtin12s_product_code[-2..-1]}3"
        when codes_00_10_20_30_40_50_60_70_80_90
          "#{gtin12s_company_code[0..3]}#{gtin12s_product_code[-1]}4"
        else
          "#{gtin12s_company_code[0..4]}#{gtin12s_product_code[-1]}"
        end
      end

      def codes_000_100_200
        /[0-2]00$/
      end

      def codes_300_400_500_600_700_800_900
        /[3-9]00$/
      end

      def codes_00_10_20_30_40_50_60_70_80_90
        /[0-9]0$/
      end
    end
  end
end
