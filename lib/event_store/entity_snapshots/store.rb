module EventStore
  module EntitySnapshots
    class Store
      include EventStore::Messaging::StreamName
      include EntityCache::Storage::Persistent

      dependency :writer, EventStore::Messaging::Writer

      alias_method :entity_class, :subject

      def configure_dependencies
        EventStore::Messaging::Writer.configure self
      end

      def category_name
        @category_name ||= CategoryName.get entity_class.to_s
      end

      def put(id, entity, version, time)
        logger.debug "Writing snapshot (ID: #{id.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"

        data = Serialize::Write.raw_data entity

        message = Message.new
        message.id = id
        message.data = data
        message.version = version
        message.time = time

        stream_name = self.stream_name id

        writer.write message, stream_name

        logger.debug "Wrote snapshot (ID: #{id.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"
      end

      module CategoryName
        def self.get(subject)
          *, subject = subject.split '::'

          stream_prefix = Casing::Camel.(subject)

          "#{stream_prefix}:snapshot"
        end
      end
    end
  end
end
