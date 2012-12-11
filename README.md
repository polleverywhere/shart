# Shart

Shart is designed to deploy [Middleman](http://middlemanapp.com/) websites, or sites built with other static site builders, to cloud storage providers, like Amazon S3 and [more](http://fog.io/0.8.1/storage/).

## Installation

Add this line to your application's Gemfile:

    gem 'shart'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shart

## Usage

A binary is in the works, but for now, you can create a ruby file like:

```ruby
require 'shart'

target = Shart::Target.new 'my-amazon-s3-bucket-name', {
  :provider                 => 'AWS',
  :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY'],
  :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID']
}

source = Shart::Source.new('/Users/johnappleseed/Projects/middleman-site/build')

target.sync source
```

Run this file and everything should sync up.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
