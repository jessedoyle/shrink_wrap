# frozen_string_literal: true

module ModelStubs
  class Version
    include Shrink::Wrap

    ATTRIBUTES = %i[
      alias
      date
    ].freeze

    attr_accessor(*ATTRIBUTES)

    transform(Shrink::Wrap::Transformer::Symbolize)

    translate(
      date: { from: :version },
      alias: { from: :testAlias, default: -> { Date.today } }
    )

    coerce(
      date: ->(v) { Date.iso8601(v) }
    )

    def initialize(opts = {})
      self.alias = opts.fetch(:alias)
      self.date = opts.fetch(:date)
    end

    def ==(other)
      self.alias == other.alias && date == other.date
    end
  end

  class Base
    include Shrink::Wrap

    ATTRIBUTES = %i[
      name
      versions
    ].freeze

    attr_accessor(*ATTRIBUTES)

    transform(Shrink::Wrap::Transformer::Symbolize)
    transform(
      Shrink::Wrap::Transformer::CollectionFromKey,
      versions: :version
    )

    translate(
      name: { from: :appName },
      versions: { from: :versions }
    )

    coerce(
      versions: Array[Version]
    )

    def initialize(opts = {})
      self.name = opts.fetch(:name)
      self.versions = opts.fetch(:versions)
    end
  end

  class TranslateAll
    include Shrink::Wrap

    ATTRIBUTES = %i[
      data
    ].freeze

    attr_accessor(*ATTRIBUTES)

    transform(Shrink::Wrap::Transformer::Symbolize)
    translate_all

    def initialize(data = {})
      self.data = data
    end
  end

  class Coerce
    ATTRIBUTES = %i[
      test
    ].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(opts = {})
      self.test = opts.fetch(:test)
    end

    def ==(other)
      test == other.test
    end

    class << self
      def coerce(data)
        new(test: data.fetch(:test).casecmp('true').zero?)
      end
    end
  end
end
