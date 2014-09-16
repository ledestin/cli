# Ninefold CLI [![Build Status](https://travis-ci.org/ninefold/cli.png)](https://travis-ci.org/ninefold/cli) [![Code Climate](https://codeclimate.com/github/ninefold/cli.png)](https://codeclimate.com/github/ninefold/cli)

This package is the official ninefold.com CLI. The Ninefold CLI allows you to access the rails console, logging, run rake tasks, and more.

## Installation

You can install this CLI with the usual `gem install` command

    gem install ninefold


## Usage

Start with

    ninefold signin

And enter your credentials for the `ninefold` portal.

Then run the following to get the list of the `app` related commands

    ninefold app help

## Updates

Ninefold frequently updates the CLI with new features. Before running the CLI, we recommend that you update your version of the gem.

#### Note
The current version (1.7.4) is no longer backwards compatible. Please ensure you have updated your gem to the newest version.

	gem update ninefold


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

All code in this library is released under the terms of the MIT license

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
