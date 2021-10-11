require_relative "opener"

module Longjump
  class Cli
    attr_reader :args

    def initialize(args:, opener:, jumpers:)
      @args = args
      @opener = opener
      @jumpers = jumpers
    end

    def call
      return help_message if args.empty? || subcommand == "help"

      return jumper_help_message if jumper && subcommand_args[0] == "help"

      return unless uri

      opener.call(uri)
    end

    private

    def jumpers
      @jumpers ||= Longjump::Jumpers
    end

    def opener
      @opener ||= Opener
    end

    def jumper
      @jumper ||= begin
        jumpers.get(subcommand)
      rescue Longjump::CouldNotFindJumper
        puts "longjump could not find jumper: #{subcommand}"
        nil
      end
    end

    def subcommand
      args[0]
    end

    def subcommand_args
      args[1..]
    end

    def subcommand_args_text
      subcommand_args.join(' ')
    end

    def help_message
      puts "longjump opens websites and apps with context"
      puts
      if jumpers.all.any?
        puts "Available jumpers:"
        jumpers.all.each do |jumper|
          puts "  #{jumper.command}: #{jumper.description}"
        end
      else
        puts "No jumpers available - try installing one"
      end
    end

    def jumper_help_message
      puts "#{jumper.command}: #{jumper.description}"

      jumper.subcommands.each do |subcommand|
        puts "- #{subcommand.command}"
      end
    end

    def uri
      @uri ||= (uri_from_jumper || uri_from_exact_match)
    end

    def uri_from_jumper
      return unless jumper
      uri = jumper.call(subcommand_args)
      puts "jumper: #{subcommand} did not recognize: #{subcommand_args_text}" unless uri
      uri
    rescue Longjump::MultipleSubcommandsMatched
      puts "jumper: #{subcommand} found multiple matches: #{subcommand_args_text}"
    end

    def uri_from_exact_match
      jumpers_with_subcommands = jumpers.all.reject { |jumper| jumper.subcommands.empty? }
      command_to_uri = jumpers_with_subcommands.each_with_object({}) do |jumper, hash|
        uri = jumper.call(args)
        hash[jumper.command] = uri if uri
      end

      if command_to_uri.size == 1
        command, uri = command_to_uri.first
        puts "#{args.join(" ")} matched jumper: #{command}"
        return uri
      end
    end

    class << self
      def call(args:, opener: nil, jumpers: nil)
        new(args: args, opener: opener, jumpers: jumpers).call
      end
    end
  end
end
