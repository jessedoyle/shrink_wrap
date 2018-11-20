# frozen_string_literal: true

module Shrink
  module Wrap
    module Transformer
      class Base
        ATTRIBUTES = %i[
          options
        ].freeze

        attr_accessor(*ATTRIBUTES)

        def initialize(opts = {})
          self.options = opts
        end

        def transform(_input)
          raise NotImplementedError, 'must define #transform in a subclass'
        end
      end
    end
  end
end
