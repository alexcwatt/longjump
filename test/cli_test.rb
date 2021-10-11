require "test_helper"

module Longjump
  class CliTest < Minitest::Test
    HELP_MESSAGE = /longjump opens websites/

    def setup
      @opener = mock
      @jumpers = stub
    end

    def test_call_with_empty_args
      empty_jumpers

      assert_output(HELP_MESSAGE) do
        call
      end
    end

    def test_call_with_help
      empty_jumpers

      assert_output(HELP_MESSAGE) do
        call("help")
      end
    end

    def test_call_with_empty_args_no_jumpers
      empty_jumpers

      assert_output(/No jumpers available/) do
        call
      end
    end

    def test_call_with_empty_args_available_jumpers
      @jumpers.expects(:all).returns([ExampleJumper]).at_least_once

      assert_output(/Available jumpers/) do
        call
      end
    end

    def test_call_with_unknown_jumper
      @jumpers.stubs(:get).raises(Longjump::CouldNotFindJumper)
      @jumpers.stubs(:all).returns([])

      assert_output(/could not find jumper: unknownjumper/) do
        call("unknownjumper")
      end
    end

    def test_call_with_example_jumper_opens_uri
      @jumpers.expects(:get).with("example").returns(ExampleJumper)
      expect_open_uri("https://example.com/")

      call("example")
    end

    def test_call_with_example_jumper_and_unsupported_argument
      @jumpers.expects(:get).with("example").returns(ExampleJumper)
      @jumpers.expects(:all).returns([ExampleJumper])

      assert_output(/jumper: example did not recognize: unknown/) do
        call("example", "unknown")
      end
    end

    def test_call_with_example_jumper_and_supported_argument_opens_uri
      @jumpers.expects(:get).with("example").returns(ExampleJumper)
      expect_open_uri("https://example.com/admin")

      call("example", "admin")
    end

    def test_call_with_admin_argument_opens_uri
      @jumpers.expects(:get).with("admin").raises(Longjump::CouldNotFindJumper).at_least_once
      @jumpers.expects(:all).returns([ExampleJumper])
      expect_open_uri("https://example.com/admin")

      assert_output(/admin matched jumper: example/) do
        call("admin")
      end
    end

    def test_call_example_with_test_warns_multiple_matches
      @jumpers.expects(:get).with("example").returns(ExampleJumper)
      @jumpers.expects(:all).returns([ExampleJumper])

      assert_output(/jumper: example found multiple matches: test/) do
        call("example", "test")
      end
    end

    private

    def call(*args)
      Longjump::Cli.call(args: args, opener: @opener, jumpers: @jumpers)
    end

    def expect_open_uri(uri)
      @opener.expects(:call).with(uri)
    end

    def empty_jumpers
      @jumpers.expects(:all).returns([]).at_least_once
    end
  end
end
