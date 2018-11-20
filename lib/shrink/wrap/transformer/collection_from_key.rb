# frozen_string_literal: true

module Shrink
  module Wrap
    module Transformer
      class CollectionFromKey < Base
        include Support::TypeCheck

        def initialize(opts = {})
          unless valid_options?(opts)
            raise ArgumentError, 'options must contain one key/value pair'
          end

          super
        end

        def transform(input)
          ensure_type!(Hash, input)
          from, to = options.first
          data = input[from]
          return input unless data.is_a?(Hash)

          mapped = map(data, to)
          input.merge(from => mapped)
        end

        private

        def map(data, to)
          data.map do |key, value|
            ensure_type!(Hash, value)
            value.merge(to => key)
          end
        end

        def valid_options?(opts)
          opts.is_a?(Hash) && opts.size == 1
        end
      end
    end
  end
end
