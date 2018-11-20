# frozen_string_literal: true

module Shrink
  module Wrap
    module Property
      class Translation
        include Support::TypeCheck

        ATTRIBUTES = %i[
          allow_nil
          default
          from
        ].freeze

        attr_accessor(*ATTRIBUTES)

        def initialize(opts = {})
          self.allow_nil = opts.fetch(:allow_nil) { false }
          self.default = opts[:default]
          self.from = opts.fetch(:from)
        end

        def translate(opts = {})
          ensure_type!(Hash, opts)
          translate_single(opts)
        end

        private

        def translate_single(opts)
          return opts[from] if allow_nil
          return opts.fetch(from) { key_error!(opts) } if default.nil?

          ensure_callable!(default, 0)
          opts.fetch(from) { default.call }
        end

        def key_error!(opts)
          pretty_hash = StringIO.new
          PP.pp(opts, pretty_hash)
          raise KeyError, <<~MSG
            Key not found `#{from.inspect}`
            Searching:
            #{pretty_hash.string}
          MSG
        end
      end
    end
  end
end
