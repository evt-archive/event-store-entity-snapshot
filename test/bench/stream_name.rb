require_relative './bench_init'

context "Stream name" do
  id = 'some-id'
  subject = EventStore::EntitySnapshots::Controls::Subject.example

  stream_name = EventStore::EntitySnapshots::Controls::StreamName.example id

  store = EventStore::EntitySnapshots::Store.build subject

  test "Category is inferred from subject" do
    assert store.stream_name(id) == stream_name
  end
end
