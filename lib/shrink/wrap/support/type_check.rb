# frozen_string_literal: true

module Shrink
  module Wrap
    module Support
      module TypeCheck
        # rubocop:disable Style/GuardClause
        def ensure_type!(klass, data)
          unless data.is_a?(klass)
            raise ArgumentError, "expected #{klass}, got: #{data.inspect}"
          end
        end

        def ensure_callable!(element, arity = nil)
          unless element.respond_to?(:call)
            raise ArgumentError, "expected callable, got: #{element.inspect}"
          end

          if arity && (!element.respond_to?(:arity) || element.arity != arity)
            raise ArgumentError, "expected callable with arity of #{arity}"
          end
        end
        # rubocop:enable Style/GuardClause
      end
    end
  end
end
