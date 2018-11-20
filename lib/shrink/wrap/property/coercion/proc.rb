# frozen_string_literal: true

module Shrink
  module Wrap
    module Property
      class Coercion
        class Proc
          include Support::TypeCheck

          attr_accessor :callable

          def initialize(callable)
            ensure_callable!(callable, 1)
            self.callable = callable
          end

          def coerce(data)
            callable.call(data)
          end
        end
      end
    end
  end
end
