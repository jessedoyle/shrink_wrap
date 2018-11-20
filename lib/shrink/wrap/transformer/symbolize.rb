# frozen_string_literal: true

module Shrink
  module Wrap
    module Transformer
      class Symbolize < Base
        DEFAULT_DEPTH = 1

        def transform(input)
          symbolize(input, 0)
        end

        private

        def symbolize(element, depth, symbolize_singular = false)
          return element if depth > options.fetch(:depth) { DEFAULT_DEPTH }

          case element
          when Hash
            symbolize_hash(element, depth + 1)
          when Enumerable
            symbolize_enumerable(element, depth)
          else
            symbolize_singular ? to_sym(element) : element
          end
        end

        def symbolize_enumerable(array, depth)
          array.map { |i| symbolize(i, depth) }
        end

        def symbolize_hash(hash, next_depth)
          hash.each_with_object({}) do |(key, value), memo|
            new_key = symbolize(key, next_depth, true)
            new_value = symbolize(value, next_depth, false)
            memo[new_key] = new_value
          end
        end

        def to_sym(element)
          element.respond_to?(:to_sym) ? element.to_sym : element
        end
      end
    end
  end
end
