# longjump

> an athletic event in which competitors jump as far as possible along the ground in one leap.

Longjump is an extensible command line tool that lets you jump into applications as far as possible with a single command.

## Installation

    $ gem install longjump

## Usage

    $ longjump

We recommend `alias lj=longjump` for convenience. But note that longjump will just tell you it has no available jumpers, unless you install a gem with a longjumper!

Gems that contain jumpers begin with `longjumper`.

## Why Longjump

Remembering URI's is hard - and is mostly solved with tools like browser bookmarks. But there are still situations where a command-line launcher that generates URI's and opens them is useful. A few examples:

* **Jump to a URL in a development environment**, where the environment's base URL is dynamic. You want something like `longjump myproject admin` to take you to the admin URL for your project, regardless of which environment you're currently using.
* **Open some internal tool with context** - maybe feeding a username into a URL structure with something like `longjump directory alex`.
* **Quickly jump from command line to a URL**, even if it's static.

## Writing Your Longjumper

You'll need to create a gem. We recommend the convention `longjumper-$name` (e.g., [`longjumper-esv`](https://github.com/alexcwatt/longjumper-esv)) for a gem that has a single jumper or `longjumpers-$collection` for a gem that has a collection of jumpers (e.g., `longjumpers-shopify`). Technically longjump is just looking for gem names beginning with `longjumper`.

Then you will need to write one or more "Jumper" classes and put them under `Longjump::Jumpers`. We recommend extending `Base`. Here is an example:

```ruby
require "longjump/jumpers/base"

module Longjump
  module Jumpers
    class GitHubDocs < Base
      require "cgi"

      command :ghdocs
      description "GitHub Docs"
      default_uri "https://docs.github.com/"

      subcommand :cli, regex: "c|cli", uri: "https://docs.github.com/en/github-cli"
      subcommand :search

      def search(*args)
        query = args.join(" ")
        "#{default_uri}en?query=#{query}"
      end
    end
  end
end
```

If your `default_uri` is dynamic, you may want to define a method for it instead:

```ruby
def default_uri
  SomeService.call
end
```

### More than URL's

Longjump can open URI's in applications, not just URL's in browsers. Here is an example of a Spotify jumper:

```ruby
module Longjump
  module Jumpers
    class Spotify < Base
      command :spotify
      description "Just a demo with Spotify"

      subcommand :gn, uri: "spotify:album:1do9XXkq2SLwDV7vsEjtjg"
    end
  end
end
```

For inspiration, here are some URI schemes to consider:

* discord
* postgres
* redis
* slack
* zoommtg

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alexcwatt/longjump.
