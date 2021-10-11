require "longjump/subcommand"

module Longjump
  module Jumpers
    class Base
      def call(args)
        return default_uri if args.empty?

        matching_subcommands = self.class.subcommands.select { |subcommand| subcommand.match?(args[0]) }

        return nil if matching_subcommands.empty?

        raise MultipleSubcommandsMatched if matching_subcommands.size > 1

        matching_subcommands.first.uri(context: self, args: args[1..])
      end

      def default_uri
        self.class.default_uri
      end

      class << self
        def call(args)
          new.call(args)
        end

        def command(name=nil)
          @commands ||= []
          if name
            @commands << name
          else
            @commands[0]
          end
        end

        def commands
          @commands ||= []
        end

        def description(set_text=nil)
          @description ||= set_text
        end

        def default_uri(set_uri=nil)
          @default_uri ||= set_uri
        end

        def subcommand(command, regex: nil, uri: nil)
          @subcommands ||= []
          @subcommands << Subcommand.new(command, regex: regex, uri: uri)
        end

        def subcommands
          @subcommands ||= []
        end
      end
    end
  end
end
