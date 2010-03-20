# Things that don't fit elsewhere
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# Licensed under the GPLv3+ http://www.gnu.org/licenses/gpl.txt

# logger support
require 'logger'

# Override default logger format
class Logger
  def format_message(severity, timestamp, progname, msg)
    "#{severity} #{timestamp} (#{$$}) #{msg}\n"
  end
end

module RAGE
    # Logger helper class
    class Logger
      private
        LOG_LEVEL = ::Logger::FATAL # FATAL ERROR WARN INFO DEBUG

        def self._instantiate_logger
           unless defined? @@logger
             @@logger = ::Logger.new(STDOUT)
             @@logger.level = LOG_LEVEL
           end 
        end 

      public
        def self.method_missing(method_id, *args)
           _instantiate_logger
           @@logger.send(method_id, args)
        end 
        def self.logger
           _instantiate_logger
           @@logger
        end
    end
end

class Module

  # Helper method to define class attributes
  def class_attr(*sym)
    syms = [sym].flatten # can pass either a single value or array to this method
    syms.each { |sym|
      module_eval "def self.#{sym}() @@#{sym} end"
      module_eval "def self.#{sym}=(x) @@#{sym}=x end"
    }
  end

end
