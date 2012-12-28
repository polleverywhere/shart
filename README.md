# Shart

Shart is a DRY approach to deploying websites generated by [Middleman](http://middlemanapp.com/), [Jekyll](http://jekyllrb.com/), or other static websites to cloud service providers that support website hosting, like [Amazon S3](http://aws.typepad.com/aws/2011/02/host-your-static-website-on-amazon-s3.html).

## Installation

Install shart from RubyGems:

    $ gem install shart

## Usage

Create a `Shartfile` in the root of your project that looks like:

```ruby
# A Middleman Shartfile.
source './build'
target 'your-aws-bucket-name', {
  :provider               =>  'AWS',
  :aws_secret_access_key  =>  'your AWS credentials',
  :aws_access_key_id      =>  'your AWS credentials'
}
```

When you're ready to publish your website, run:

    $ shart

Don't forget to run `middleman build` before you `shart` if you're using Middleman.

After you successfully shart, be sure to [read the blog post about hosting a website on S3](http://aws.typepad.com/aws/2011/02/host-your-static-website-on-amazon-s3.html) if you haven't already configured your S3 bucket to do so.

## Supported targets

Shart has only been tested with Amazon S3 buckets.

In theory, you can shart into any [storage provider that Fog supports](http://fog.io/about/getting_started.html).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
