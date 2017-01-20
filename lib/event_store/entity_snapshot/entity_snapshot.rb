module EventStore
  module EntitySnapshot
    def self.included(cls)
      cls.class_exec do
        prepend Configure
        prepend Get
        prepend Put

        include ::Messaging::StreamName
        include EntityCache::Storage::Persistent

        dependency :write, ::Messaging::EventStore::Write

        alias_method :entity_class, :subject
      end
    end

    Virtual::Method.define self, :configure

    def snapshot_stream_name(id)
      category_name = category
      category_name = "#{category_name}:snapshot"

      stream_name id, category_name
    end

    module Configure
      def configure
        ::Messaging::EventStore::Write.configure self

        super
      end

      alias_method :configure_dependencies, :configure
    end

    module Get
      def get(id)
        stream_name = snapshot_stream_name id

        logger.trace "Reading snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})"

        read = EventSource::EventStore::HTTP::Read.build stream_name, batch_size: 1, precedence: :desc

        event = nil
        read.() do |_event|
          event = _event
          break
        end

        if event.nil?
          logger.debug "Snapshot could not be read (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})"
          return
        end

        message = ::Messaging::Message::Import.(event, Message)
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

        data = Transform::Write.raw_data entity

        message = Message.new
        message.id = id
        message.data = data
        message.version = version
        message.time = time

        write.(message, stream_name)

        logger.debug "Wrote snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"
      end
    end
  end
end
