require_relative '../bench_init'

context "Reading snapshots that have been previously written" do
  id = Controls::ID.get
  control_entity = EventStore::EntitySnapshots::Controls::Entity.example
  control_version = EventStore::EntitySnapshots::Controls::Version.example
  control_time = Controls::Time.reference

  store = EventStore::EntitySnapshots::Store.build control_entity.class

  store.put id, control_entity, control_version, control_time

  entity, version, time = store.get id

  test "Original entity is returned" do
    assert entity == control_entity
    assert entity.object_id != control_entity.object_id
  end

  test "Version is returned" do
    assert version == control_version
  end

  test "Snapshot time is returned" do
    assert time == control_time
  end
end
