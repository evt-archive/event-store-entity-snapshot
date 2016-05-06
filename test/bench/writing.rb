require_relative './bench_init'

context "Writing snapshots" do
  id = Controls::ID.get
  entity = EventStore::EntitySnapshots::Controls::Entity.example
  version = EventStore::EntitySnapshots::Controls::Version.example

  store = EventStore::EntitySnapshots::Store.build entity.class
  SubstAttr::Substitute.(:writer, store)
  SubstAttr::Substitute.(:clock, store)
  store.clock.now = Controls::Time::Raw.example

  store.put id, entity, version

  test "Snapshot message is written" do
    control_message = EventStore::EntitySnapshots::Controls::Message.example

    assert store.writer do
      written? do |message|
        message == control_message
      end
    end
  end
end
