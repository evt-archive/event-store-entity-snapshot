require_relative './bench_init'

context "Activating library" do
  context "Not activated" do
    test "Event store persistent store is unknown" do
      assert proc { EntityCache.build :some_subject, persistent_store: :event_store } do
        raises_error? EntityCache::Storage::Persistent::Error
      end
    end
  end

  context "Activated" do
    EventStore::EntitySnapshot.activate

    test "Event store persistent store can be used by entity caches" do
      cache = EntityCache.build :some_subject, persistent_store: :event_store

      assert cache.persistent_store.is_a?(EventStore::EntitySnapshot::Store)
    end
  end
end
