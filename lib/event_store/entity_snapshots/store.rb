module EventStore
  module EntitySnapshots
    class Store
      include EventStore::Messaging::StreamName
      include EntityCache::Storage::Persistent

      def category_name
        @category_name ||= CategoryName.get subject.to_s
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
