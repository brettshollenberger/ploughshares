module Ploughshares
  class GTIN12
    attr_accessor :code

    def initialize(options = {})
      @code = options.fetch(:code)
    end

    def company_code
      code[0..4]
    end

    def product_code
      code[5..-1]
    end
  end
end
