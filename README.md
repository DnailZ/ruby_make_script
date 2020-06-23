# RubyMakeScript


## Installation


Or install it yourself as:

    ```
    $ gem install ruby_make_script
    ```

## Usage

Write ruby_make_script like this:

```ruby
require "ruby_make_script"

make do
    :run .from "a.out" do
        r "./a.out"
    end
    "a.out" .from "test.c" do
        r "gcc test.c"
    end
end
```

then run:

```
$ ruby make.rb
$ ruby make.rb run
```

It works very similar to GNU Make.

Here is a little complex one:

```ruby
require "ruby_make_script"

def CC(*str)
    r "gcc", "-I.", *str
end

mkdir? ".build"                     # `?` take error as warning, and also return a bool to indicate success/failure.
sources = Dir.glob("**/*.c")        # Dir.glob will be very useful
objects = sources.map{
    |f| ".build/" + f.gsub('.c', '.o')
}
headers = Dir.glob("**/*.h")

make do
    :app .from "prog" do
        runfile $d[0]               # $d: dependencies array
    end
    "prog" .from(*objects) do
        CC "-o", $t[0], *$d         # $t: targets array
    end
    sources.zip(objects).each do |s, o|
        o .from(s, *headers) do
            CC "-c", "-o", $t[0], $d[0]
        end
    end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_make_script. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RubyMakeScript project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ruby_make_script/blob/master/CODE_OF_CONDUCT.md).
