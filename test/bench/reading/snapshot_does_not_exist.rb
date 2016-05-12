require_relative '../bench_init'

context "Reading snapshots that have not been written" do
  id = Identifier::UUID::Random.get

  store = EventStore::EntitySnapshot::Controls::Store.example

  entity, version, time = store.get id

  test "No entity is returned" do
    assert entity == nil
  end

  test "No version is returned" do
    assert version == nil
  end

  test "No time is returned" do
    assert time == nil
  end
end
