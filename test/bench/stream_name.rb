require_relative './bench_init'

context "Stream name" do
  entity_class = EventStore::EntitySnapshots::Controls::Entity::ExampleEntity

  store = EventStore::EntitySnapshots::Store.build entity_class

  test "Category is inferred from subject" do
    id = 'some-id'

    stream_name = EventStore::EntitySnapshots::Controls::StreamName.example id

    assert store.stream_name(id) == stream_name
  end
end
