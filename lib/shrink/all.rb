# frozen_string_literal: true

require 'pp'
require_relative 'wrap/version'
require_relative 'wrap/metadata'
require_relative 'wrap/support/type_check'
require_relative 'wrap/property/translation'
require_relative 'wrap/property/coercion'
require_relative 'wrap/property/coercion/class'
require_relative 'wrap/property/coercion/enumerable'
require_relative 'wrap/property/coercion/proc'
require_relative 'wrap/transformer/base'
require_relative 'wrap/transformer/symbolize'
require_relative 'wrap/transformer/collection_from_key'
