require "fluent/plugin/output"
require 'traildb'

module Fluent
  module Plugin
    class TraildbOutput < Fluent::Plugin::Output
      Fluent::Plugin.register_output("traildb", self)

      config_param :path, :string
      config_param :fields, :array
      config_param :uuid_key, :string, default: 'uuid'

      def write(chunk)
        cons = Traildb::TrailDBConstructor.new(@path+dump_unique_id_hex(chunk.unique_id), @fields)
        chunk.each do |time, record|
          uuid = record[@uuid_key]
          values = @fields.map{|f|record[f]}
          cons.add(uuid, time.to_i, values)
        end
        cons.finalize
      end
    end
  end
end
