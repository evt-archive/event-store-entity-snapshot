module EventStore
  module EntitySnapshot
    class Message
      include EventStore::Messaging::Message

      attribute :id
      attribute :data
      attribute :version
      attribute :time

      def entity(entity_class)
        Transform::Read.instance data, entity_class
      end

      module Transformer
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
