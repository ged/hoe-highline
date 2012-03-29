#!/usr/bin/env ruby

require 'hoe'
require 'highline'
require 'forwardable'

# Add Highline command-line interaction functions to Hoe Rakefiles.
module Hoe::Highline
	extend Forwardable

	# Library version constant
	VERSION = '0.1.0'

	# Version-control revision constant
	REVISION = %q$Revision$

	# HighLine color scheme
	COLOR_SCHEME = {
		:header    => [ :bold, :yellow ],
		:subheader => [ :bold, :white ],
		:values    => [ :bold, :white ],
		:error     => [ :red ],
		:warning   => [ :yellow ],
		:message   => [ :reset ],
	}


	# The HighLine object used for prompting
	attr_accessor :highline


	### Set up the plugin's instance variables.
	def initialize_highline
		HighLine.color_scheme = HighLine::ColorScheme.new( COLOR_SCHEME )
		@highline = HighLine.new( $stdin, $stderr )

		self.extra_dev_deps << ['hoe-highline', "~> #{VERSION}"] unless
			self.name == 'hoe-highline'
	end


	### Hoe hook -- add the Highline functions to Kernel when the plugin is
	### loaded.
	def define_highline_tasks
		$terminal = self.highline

		::Kernel.extend( Forwardable )
		::Kernel.def_delegators :$terminal, :agree, :ask, :choose, :color, :list, :say
	end


end # module Hoe::Highline

