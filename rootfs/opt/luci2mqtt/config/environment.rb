# frozen_string_literal: true

require 'bundler'
Bundler.require

require "active_support/all"
require "active_model"

loader = Zeitwerk::Loader.new

root = "#{__dir__}/../app"

Dir.entries(root)
   .select { |entry| File.directory? File.join(root, entry) and not %w[. ..].include? entry}
   .map { |entry| File.join(root, entry) }
   .each { |directory| loader.push_dir(directory) }
loader.setup # ready!

Dir.glob("#{__dir__}/initializers/*.rb").each { |file| require_relative file }
