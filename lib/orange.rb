require "zeitwerk"
require "sorbet-runtime"
require "date"

require_relative "results"

module Orange
end

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/orange", namespace: Orange)
loader.collapse("#{__dir__}/orange/values")
loader.setup
