require_relative "jumpers/base"

longjumper_gems = Gem::Specification.map { |gem| gem.name.downcase }.filter { |name| name.start_with?("longjumper") }
longjumper_gems.each { |gem| require gem }

module Longjump
  module Jumpers
    def self.all
      constants.sort.map { |c| const_get(c) }.select { |c| c < Base }
    end

    def self.get(jumper_name)
      jumpers = all.select { |jumper| jumper.commands.include?(jumper_name.to_sym) }
      raise Longjump::CouldNotFindJumper if jumpers.empty?

      jumpers.first
    end
  end
end
