# frozen_string_literal: true

module Shrink
  module Wrap
    module Property
      class Coercion
        class Class
          include Support::TypeCheck

          attr_accessor :klass

          def initialize(klass)
            ensure_type!(::Class, klass)
            self.klass = klass
          end

          def coerce(data)
            return klass.shrink_wrap(data) if klass.respond_to?(:shrink_wrap)
            return klass.coerce(data) if klass.respond_to?(:coerce)

            klass.new(data)
          end
        end
      end
    end
  end
end
