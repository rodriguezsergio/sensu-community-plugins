#!/usr/bin/env ruby
#
# Check Available Entropy Plugin
#

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'

class CheckEntropy < Sensu::Plugin::Check::CLI

  option :warn,
      :short => '-w WARN',
      :proc => proc {|a| a.to_i },
      :default => 60

  option :crit,
      :short => '-c CRIT',
      :proc => proc {|a| a.to_i },
      :default => 30

  def run
    unknown "invalid entropy treshold" if config[:crit] < 0 or config[:warn] < 0

    entropy = 0

    File.open("/proc/sys/kernel/random/entropy_avail", "r").each_line do |line|
      entropy = line.strip.split(/\s+/).shift.to_i
    end

    critical if entropy < config[:crit]
    warning if entropy < config[:warn]
    ok
  end
end