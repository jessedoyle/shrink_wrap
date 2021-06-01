# frozen_string_literal: true

module Shrink
  module Wrap
    class Metadata
      def add_transformer(klass, opts = {})
        transformers.push(klass.new(opts))
      end

      def add_translation(property, opts = {})
        params = { from: property }.merge(opts)
        translations[property] = Shrink::Wrap::Property::Translation.new(params)
      end

      def add_coercion(property, coercion)
        coercions[property] = Shrink::Wrap::Property::Coercion.new(coercion)
      end

      def transform(data)
        transformers.each do |transformer|
          data = transformer.transform(data)
        end
        data
      end

      def translate(data)
        return data if translate_all

        translations.transform_values do |translation|
          translation.translate(data)
        end
      end

      def translate_all!
        @translate_all = true
      end

      def coerce(data)
        data.each_with_object({}) do |(property, value), memo|
          next if value.nil?

          coercion = coercions[property]

          memo[property] = if coercion
                             coercion.coerce(value)
                           else
                             value
                           end
        end
      end

      private

      def translate_all
        @translate_all ||= false
      end

      def transformers
        @transformers ||= []
      end

      def translations
        @translations ||= {}
      end

      def coercions
        @coercions ||= {}
      end
    end
  end
end
