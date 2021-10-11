module Longjump
  class Subcommand
    attr_reader :command, :regex

    def initialize(command, regex: nil, uri: nil)
      @command = command
      @regex = regex ? /^(#{regex})$/ : nil
      @uri = uri
    end

    def match?(name)
      name == command.to_s || regex&.match?(name)
    end

    def uri(context:, args: nil)
      return @uri if @uri

      begin
        return context.send(command, *args)
      rescue ArgumentError
        puts "Warning: #{command} does not support arguments"
        return context.send(command)
      end
    end
  end
end
