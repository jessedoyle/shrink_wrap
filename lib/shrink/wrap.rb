# frozen_string_literal: true

require_relative 'all'

module Shrink
  module Wrap
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def transform(klass, opts = {})
        metadata.add_transformer(klass, opts)
      end

      def translate(opts = {})
        opts.each do |key, value|
          metadata.add_translation(key, value)
        end
      end

      def translate_all
        metadata.translate_all!
      end

      def coerce(opts = {})
        opts.each do |key, value|
          metadata.add_coercion(key, value)
        end
      end

      def shrink_wrap(data)
        transformed = metadata.transform(data)
        translated = metadata.translate(transformed)
        coerced = metadata.coerce(translated)
        new(coerced)
      end

      private

      def metadata
        @metadata ||= Metadata.new
      end
    end
  end
end
