module EventStore
  module EntitySnapshots
    class Message
      include EventStore::Messaging::Message

      attribute :id
      attribute :data
      attribute :version
      attribute :time

      def entity(entity_class)
        Serialize::Read.instance data, entity_class
      end

      module Serializer
        def self.raw_data(instance)
          instance.to_h
        end

        def self.instance(raw_data)
          Message.build raw_data
        end
      end
    end
  end
end
