module Ploughshares
  class GTIN6
    class << self
      def from(source_type, source)
        case source_type.to_sym
        when :gtin12
          from_gtin_12(source)
        else
        end
      end

      def from_gtin_12(source)
        gtin12       = GTIN12.new(code: source)
        company_code = gtin12.company_code
        product_code = gtin12.product_code

        case company_code
        when /[0-2]00$/
          code = "#{company_code[0..1]}#{product_code[-3..-1]}#{company_code[2]}"
        when /[3-9]00$/
          code = "#{company_code[0..2]}#{product_code[-2..-1]}3"
        when /[0-9]0$/
          code = "#{company_code[0..3]}#{product_code[-1]}4"
        else
          code = "#{company_code[0..4]}#{product_code[-1]}"
        end

        new(code: code)
      end
    end

    attr_accessor :code

    def initialize(options = {})
      @code = options.fetch(:code, nil)
    end

    def to_s
      code
    end
  end
end
