# frozen_string_literal: true

module Shrink
  module Wrap
    module Property
      class Coercion
        class Enumerable
          include Support::TypeCheck

          attr_accessor :enumerable

          def initialize(enumerable)
            ensure_type!(::Enumerable, enumerable)
            self.enumerable = wrap(enumerable.first)
          end

          def coerce(data)
            return coerce_hash(data) if enumerable.size > 1

            coerce_enumerable(data)
          end

          private

          def coerce_hash(data)
            ensure_type!(Hash, data)
            key_klass, value_klass = enumerable
            data.each_with_object({}) do |(key, value), memo|
              coerced_key = Class.new(key_klass).coerce(key)
              coerced_value = Class.new(value_klass).coerce(value)
              memo[coerced_key] = coerced_value
            end
          end

          def coerce_enumerable(data)
            ensure_type!(::Enumerable, data)
            klass = enumerable.first
            data.map do |element|
              Class.new(klass).coerce(element)
            end
          end

          def wrap(element)
            [element].flatten
          end
        end
      end
    end
  end
end
