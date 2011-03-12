#!/usr/bin/env rake

require 'hoe'

Hoe.add_include_dirs 'lib'

Hoe.plugin :highline
Hoe.plugin :mercurial
Hoe.plugin :signing

Hoe.plugins.delete :rubyforge

hoespec = Hoe.spec 'hoe-highline' do
	self.readme_file = 'README.md'
	self.history_file = 'History.md'

	self.developer 'Michael Granger', 'ged@FaerieMUD.org'

	self.extra_deps.push *{
		'highline' => '~> 1.6',
		'hoe' => '~> 2.8',
	}

	self.spec_extras[:licenses] = ["BSD"]
	self.spec_extras[:signing_key] = '/Volumes/Keys/ged-private_gem_key.pem'

	self.require_ruby_version( '>=1.8.7' )

	self.hg_sign_tags = true if self.respond_to?( :hg_sign_tags= )

	self.rdoc_locations << "deveiate:/usr/local/www/public/code/#{remote_rdoc_dir}"

	unless self.respond_to?( :highline )
		abort "Ack! The plugin doesn't seem to be loaded; that won't do at all."
	end
end


desc "A series of demos of how this plugin can be used"
task :demo do
	say "<%= color 'hoe-highline Demo', :header %>"

	say "\n<%= color 'You can prompt for a yes-or-no answer with agree()', :subheader %>"
	if agree "Know what I mean (nudge, nudge, wink, wink)? <%= color '[yn]', :values %> ", true
		say "What's it like?"
	else
		say "Ah, more's the pity."
	end

	say "\n<%= color 'You can ask for input with ask()', :subheader %>"
	result = ask "What could be better than that? "
	say "Actually, that was a rhetorical question, but you answered: %p" % [ result ]

	say "\n<%= color 'You can also ask() for things like passwords with a little " +
	    "configuration', :subheader %>"
	result = ask( "Super sekrit password: " ) {|q| q.echo = color("*", :warning) }
	say "Okay, using your %d-character password for something nefarious..." % [ result.length ]

	say "\n<%= color 'You can also use choose() for building a menu.', :subheader %>"
	say "What editor do you prefer?"
	choice = choose( 'Emacs', 'vi', 'Textmate', 'pico', 'RubyMine', 'FreeRIDE' )
	say "Good to know (you picked %p)." % [ choice ]

	say "\n<%= color 'Or build a complex menu using a block.', :subheader %>"
	say "Announce a new release:"
	done = false
	remaining = [ :mail, :blog, :twitter ]
	until done || remaining.empty?
		choose do |menu|
			menu.choice( "ruby-talk" ) do
				say "Sending mail!"
				remaining.delete( :mail )
			end if remaining.include?( :mail )

			menu.choice( "Blog" ) do
				say "Posting to blog.you.com!"
				remaining.delete( :blog )
			end if remaining.include?( :blog )

			menu.choice( "Twitter" ) do
				say "Twerp! Twerp!"
				remaining.delete( :twitter )
			end if remaining.include?( :twitter )

			menu.choice( "Exit" ) do
				done = true
			end
		end
	end

	say "\n<%= color 'There is also a list() function for display stuff in a compact " +
	    "list', :subheader %>"
	say "For example, here's a list of the available tasks:"
	say list( Rake.application.tasks.map(&:to_s), :columns_across, 4 )

end


ENV['VERSION'] ||= hoespec.spec.version.to_s

begin
	include Hoe::MercurialHelpers

	### Task: prerelease
	desc "Append the package build number to package versions"
	task :pre do
		rev = get_numeric_rev()
		trace "Current rev is: %p" % [ rev ]
		hoespec.spec.version.version << "pre#{rev}"
		Rake::Task[:gem].clear

		Gem::PackageTask.new( hoespec.spec ) do |pkg|
			pkg.need_zip = true
			pkg.need_tar = true
		end
	end

	### Make the ChangeLog update if the repo has changed since it was last built
	file '.hg/branch'
	file 'ChangeLog' => '.hg/branch' do |task|
		$stderr.puts "Updating the changelog..."
		content = make_changelog()
		File.open( task.name, 'w', 0644 ) do |fh|
			fh.print( content )
		end
	end

	# Rebuild the ChangeLog immediately before release
	task :prerelease => 'ChangeLog'

rescue NameError => err
	task :no_hg_helpers do
		fail "Couldn't define the :pre task: %s: %s" % [ err.class.name, err.message ]
	end

	task :pre => :no_hg_helpers
	task 'ChangeLog' => :no_hg_helpers

end

