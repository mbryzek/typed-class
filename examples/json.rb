require 'typed_class'
require 'json'

class MongoMetadata < TypedClass
  field :primary, String

  def to_s
    "primary: #{primary}"
  end
end

class Mongod < TypedClass
  field :shard, String
  field :port, Fixnum
  field :metadata, MongoMetadata
end

raw  = "{ \"shard\":\"1\", \"port\": 2, \"metadata\" : { \"primary\" : \"host1\"}}"
json = JSON.parse(raw)

mongoMetaData = MongoMetadata.new(json["metadata"]["primary"])
mongo = Mongod.new(json["shard"], json["port"], mongoMetaData)

puts "Mongod: mongo.index[%s] mongo.port[%s] mongo.metadata[%s]" % [mongo.shard, mongo.port, mongo.metadata]
