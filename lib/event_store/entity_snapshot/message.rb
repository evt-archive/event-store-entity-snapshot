module EventStore
  module EntitySnapshot
    class Message
      include ::Messaging::Message

      attribute :id
      attribute :data
      attribute :version
      attribute :time

      def entity(entity_class)
        Transform::Read.instance data, entity_class
      end
    end
  end
end
