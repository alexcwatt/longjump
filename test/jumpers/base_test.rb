require "test_helper"

module Longjump
  module Jumpers
    class EmptyJumperTest < Minitest::Test
      def test_command_nil
        assert_nil EmptyJumper.command
      end

      def test_default_uri_nil
        assert_nil EmptyJumper.default_uri
      end

      def test_description_nil
        assert_nil EmptyJumper.description
      end

      def test_subcommands_empty
        assert_empty EmptyJumper.subcommands
      end
    end

    class ExampleJumperTest < Minitest::Test
      def test_command
        assert_equal :example, ExampleJumper.command
      end

      def test_default_uri
        assert_equal "https://example.com/", ExampleJumper.default_uri
      end

      def test_description
        assert_equal "Popular example.com pages", ExampleJumper.description
      end

      def test_subcommands
        subcommands = ExampleJumper.subcommands.map(&:command)
        assert_equal [:admin, :storefront], subcommands
      end
    end
  end
end
