#--
# Author:: Lamont Granquist <lamont@chef.io>
# Copyright:: Copyright 2010-2018, Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "stringio" unless defined?(StringIO)

class Chef
  module Mixin
    module TrainHelpers
      def file_exist?(*args)
        if Chef::Config.target_mode?
          Chef.run_context.transport_connection.file(args[0]).exist?
        else
          File.exist?(*args)
        end
      end

      # XXX: modifications to the StringIO won't get written back
      def file_open(*args, &block)
        if Chef::Config.target_mode?
          content = Chef.run_context.transport_connection.file(args[0]).content
          string_io = StringIO.new content
          yield string_io if block_given?
          string_io
        else
          File.open(*args, &block)
        end
      end
    end
  end
end
