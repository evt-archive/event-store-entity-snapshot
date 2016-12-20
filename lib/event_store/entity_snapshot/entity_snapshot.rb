module EventStore
  module EntitySnapshot
    def self.included(cls)
      cls.class_exec do
        prepend Configure
        prepend Get
        prepend Put

        include EventStore::Messaging::StreamName
        include EntityCache::Storage::Persistent

        dependency :writer, EventStore::Messaging::Writer

        alias_method :entity_class, :subject
      end
    end

    Virtual::Method.define self, :configure

    def snapshot_stream_name(id)
      category_name = self.category_name
      category_name = "#{category_name}:snapshot"

      stream_name id, category_name
    end

    module Configure
      def configure
        EventStore::Messaging::Writer.configure self

        super
      end

      alias_method :configure_dependencies, :configure
    end

    module Get
      def get(id)
        stream_name = snapshot_stream_name id

        logger.trace "Reading snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})"

        reader = EventStore::Client::HTTP::Reader.build stream_name, slice_size: 1, direction: :backward

        event = nil
        reader.each do |_event|
          event = _event
          break
        end

        if event.nil?
          logger.debug "Snapshot could not be read (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})"
          return
        end

        message = Serialize::Read.instance event.data, Message
        entity = message.entity entity_class

        version, time = message.version, message.time

        logger.debug "Read snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name}, Version: #{version.inspect}, Time: #{time})"

        return entity, version, time
      end
    end

    module Put
      def put(id, entity, version, time)
        stream_name = snapshot_stream_name id

        logger.trace "Writing snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"

        data = Serialize::Write.raw_data entity

        message = Message.new
        message.id = id
        message.data = data
        message.version = version
        message.time = time

        writer.write message, stream_name

        logger.debug "Wrote snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"
      end
    end
  end
end
