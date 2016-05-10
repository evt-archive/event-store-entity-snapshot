module EventStore
  module EntitySnapshot
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

      def get(id)
        logger.trace "Reading snapshot (ID: #{id.inspect}, Entity Class: #{entity_class.name})"

        stream_name = self.stream_name id

        reader = EventStore::Client::HTTP::Reader.build stream_name, slice_size: 1, direction: :backward

        event = nil
        reader.each do |_event|
          event = _event
          break
        end

        if event.nil?
          logger.debug "Snapshot could not be read (ID: #{id.inspect}, Entity Class: #{entity_class.name})"
          return
        end

        message = Serialize::Read.instance event.data, Message
        entity = message.entity entity_class

        version, time = message.version, message.time

        logger.debug "Read snapshot (ID: #{id.inspect}, Entity Class: #{entity_class.name}, Version: #{version.inspect}, Time: #{time})"

        return entity, version, time
      end

      def put(id, entity, version, time)
        logger.trace "Writing snapshot (ID: #{id.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"

        data = Serialize::Write.raw_data entity

        message = Message.new
        message.id = id
        message.data = data
        message.version = version
        message.time = time

        stream_name = self.stream_name id

        writer.write message, stream_name

        logger.debug "Wrote snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"
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
