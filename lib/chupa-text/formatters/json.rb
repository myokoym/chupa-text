# Copyright (C) 2013  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require "json"

module ChupaText
  module Formatters
    class JSON
      def initialize(output)
        @output = output
        @formatted = {}
      end

      def format_start(data)
        format_headers(data, @formatted)
        @formatted["texts"] = []
      end

      def format_extracted(data)
        text = {}
        format_headers(data, text)
        text["body"] = data.body
        @formatted["texts"] << text
      end

      def format_finish(data)
        @output << ::JSON.pretty_generate(@formatted)
        @output << "\n"
      end

      private
      def format_headers(data, target)
        format_header("mime-type", data.mime_type, target)
        format_header("uri",       data.uri,       target)
        format_header("size",      data.size,      target)
        data.attributes.each do |name, value|
          format_header(name, value, target)
        end
      end

      def format_header(name, value, target)
        return if value.nil?
        target[name] = value
      end
    end
  end
end
