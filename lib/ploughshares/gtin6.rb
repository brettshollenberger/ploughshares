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
        Converters::GTIN12ToGTIN6Converter.new(gtin12: source).convert!
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
