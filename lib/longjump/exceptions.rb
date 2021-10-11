module Longjump
  class Error < StandardError; end

  class CouldNotFindJumper < Error; end

  class MultipleSubcommandsMatched < Error; end
end
