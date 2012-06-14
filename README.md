# Rarity - a recursive image optimiser

If you understand why you need this there's something wrong with you or you have very strange needs.

This is a tool built for a friend to recursively optimise a directory of images, keeping track of progress to support partial runs and update runs, using optipng, jpegoptim and gifsicle.

## Dependencies

Rarity makes use of:

* optipng
* jpegoptim
* gifsicle

You will need to install these prior to running rarity.

Additionally, the sqlite3 gem is used for the tracking database. This has the following package dependencies on Ubuntu:

* libsqlite3-dev

Gem dependencies are installed automatically when installing rarity.

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

## License

See the LICENSE file. Long story short, MIT, go crazy.