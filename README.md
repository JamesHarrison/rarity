# Spike

If you understand why you need this there's something wrong with you or you have very strange needs.

This is a tool built for a friend to recursively optimise a directory of images, keeping track of progress to support partial runs and update runs, using optipng, jpegoptim and gifsicle.

## Installation

Add this line to your application's Gemfile:

    gem 'rarity'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rarity

## Usage

Basic usage:

    rarity optim -d some/path

Spike will then optimise everything under that directory.

You can find more help with:

    rarity -h
    rarity optim -h
    rarity tracker -h

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
