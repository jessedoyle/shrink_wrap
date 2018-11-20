# frozen_string_literal: true

module Shrink
  module Wrap
    module Property
      class Coercion
        attr_accessor :base

        def initialize(value)
          case value
          when ::Class
            self.base = Coercion::Class.new(value)
          when ::Enumerable
            self.base = Coercion::Enumerable.new(value)
          when ::Proc
            self.base = Coercion::Proc.new(value)
          else
            fail!(value)
          end
        end

        def coerce(data)
          base.coerce(data)
        end

        private

        def fail!(value)
          msg = "expected Class, Enumerable or Proc, got: #{value.inspect}"
          raise ArgumentError, msg
        end
      end
    end
  end
end
