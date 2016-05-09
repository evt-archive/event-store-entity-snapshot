module EventStore
  module EntitySnapshot
    def self.activate
      EntityCache::Storage::Persistent.add :event_store, Store
    end
  end
end
