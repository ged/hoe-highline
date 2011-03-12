# hoe_highline

* http://bitbucket.org/ged/hoe-highline

## Description

A Hoe plugin for building interactive Rake tasks.

Hoe-highline, as you might have guessed from the name, adds prompting and
displaying functions from the [HighLine][highline] gem to your Rake
environment, allowing you to ask questions, prompt for passwords, build menus,
and other fun stuff.


## Installation

    gem install hoe-highline


## Usage

	# in your Rakefile

	Hoe.plugin :highline

	Hoe.spec 'mygem' do
		
		# Configure the highline terminal to your liking
		highline.wrap_at = :auto  # Auto-wrap output
		
	end

	# Generate an email, show it, confirm they want to send it, then prompt
	# for a SMTP connection information before sending
	task :send_email do
		message = generate_email( :full )
		say "About to send this:"
		say( mail )

		if agree( "Okay to send it? " )
			require 'socket'
			require 'net/smtp'
			require 'etc'

			username = ask( "Email username: " ) do |q|
				q.default = Etc.getlogin  # default to the current user
			end
			password = ask( "Email password: " ) do |q|
				q.echo = '*'  # Hide the password
			end

			say "Creating SMTP connection to #{SMTP_HOST}:#{SMTP_PORT}"
			smtp = Net::SMTP.new( SMTP_HOST, SMTP_PORT )
			smtp.set_debug_output( $stderr )
			smtp.esmtp = true
			smtp.enable_starttls

			helo = Socket.gethostname
			smtp.start( helo, username, password, :plain ) do |smtp|
				smtp.send_message( message, email_from, *email_to )
			end
		else
			abort "Okay, aborting."
		end
	end

There is also a 'demo' task in this library's Rakefile that has a few ideas for things you might want to do.


## Contributing

You can check out the current development source with Mercurial via its [Bitbucket project][bitbucket]. Or if you prefer Git, via [its Github mirror][github].

After checking out the source, run:

    $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the API documentation.


## License

Copyright (c) 2011, Michael Granger
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the author/s, nor the names of the project's
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


[highline]: http://highline.rubyforge.org/
[bitbucket]: https://bitbucket.org/ged/hoe-highline
[github]: https://github.com/ged/ruby-openldap

