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

Create a `Shartfile` in the root of your project.

```ruby
# A Middleman Shartfile. Don't forget to run `middleman build` before you `shart`!
source './build'
target 'your-aws-bucket-name', {
  :provider               =>  'AWS',
  :aws_secret_access_key  =>  'your AWS credentials',
  :aws_access_key_id      =>  'your AWS credentials'
}
```

Now run `shart` from your project root and BOOM! Your website will be deployed. If you're using Middleman, don't forget to run build first.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
