require "test_helper"

module Longjump
  class JumpersTest < Minitest::Test
    def test_get
      assert_equal Jumpers::Docs, Jumpers.get("docs")
      assert_equal Jumpers::Spin, Jumpers.get("spin")
      assert_raises CouldNotFindJumper do
        Jumpers.get("unknown_jumper")
      end
    end

    def test_all
      assert_includes Jumpers.all, Jumpers::Docs
      assert_includes Jumpers.all, Jumpers::Spin
    end
  end
end
