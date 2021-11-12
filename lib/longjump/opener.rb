module Longjump
  class Opener
    def self.call(uri)
      puts "Opening #{uri}"
      exec("open #{uri}")
    end
  end
end
