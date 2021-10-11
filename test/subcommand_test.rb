require "test_helper"

module Longjump
  class SubcommandTest < Minitest::Test
    def test_match_without_regex
      subcommand = Subcommand.new(:search)

      assert subcommand.match?("search")
      refute subcommand.match?("s")
    end

    def test_match_with_regex
      subcommand = Subcommand.new(:search, regex: "s|search|q")

      ["s", "search", "q"].each do |arg|
        assert subcommand.match?(arg)
      end

      ["se", "qu"].each do |arg|
        refute subcommand.match?(arg)
      end
    end

    def test_uri_with_static_uri
      spotify_getty_uri = "spotify:artist:0I4Bk2s2BUJyykCwtxx8Xx"
      subcommand = Subcommand.new(:getty, uri: spotify_getty_uri)

      assert_equal subcommand.uri(context: nil), spotify_getty_uri
    end

    def test_uri_with_contextual_uri
      jumper = ExampleJumper.new
      subcommand = Subcommand.new(:admin)

      assert_equal subcommand.uri(context: jumper), "https://example.com/admin"
    end

    def test_uri_with_contextual_uri_does_not_support_arguments
      jumper = ExampleJumper.new
      subcommand = Subcommand.new(:admin)

      assert_output(/Warning: admin does not support arguments/) do
        url = subcommand.uri(context: jumper, args: ["example"])

        assert_equal url, "https://example.com/admin"
      end
    end
  end
end
