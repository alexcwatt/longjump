class ExampleJumper < Longjump::Jumpers::Base
  command :example
  description "Popular example.com pages"
  default_uri "https://example.com/"

  subcommand :admin, regex: "a|test"
  subcommand :storefront, regex: "test"

  def admin
    "https://example.com/admin"
  end
end
