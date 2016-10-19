require "spec"
require "../src/messenger-bot"
require "webmock"
def fixture(filename)
  fixture_path = File.expand_path(".")
  File.read("spec/fixtures/#{filename}")
end
