module Longjump
  class Opener
    def self.call(uri)
      exec("open #{uri}")
    end
  end
end
