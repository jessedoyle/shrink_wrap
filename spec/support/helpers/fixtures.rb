# frozen_string_literal: true

module Helpers
  module Fixtures
    PATH = File.join(
      Gem.loaded_specs['shrink_wrap'].full_gem_path,
      'spec',
      'fixtures'
    ).freeze

    def read_fixture(*path)
      File.read(File.join(PATH, *path))
    end
  end
end
