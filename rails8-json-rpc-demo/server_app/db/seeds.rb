# Server App Seed Data

puts "Creating sample received records..."

# Create some sample received records to demonstrate the interface
sample_records = [
  {
    record_type: 'user',
    source_id: 1,
    data: {
      id: 1,
      name: 'John Doe',
      email: 'john@example.com',
      age: 30,
      created_at: '2024-12-11T10:00:00Z'
    },
    received_at: 2.hours.ago,
    processed_at: 1.hour.ago
  },
  {
    record_type: 'user',
    source_id: 2,
    data: {
      id: 2,
      name: 'Jane Smith',
      email: 'jane@example.com',
      age: 25,
      created_at: '2024-12-11T10:15:00Z'
    },
    received_at: 1.hour.ago,
    processed_at: 30.minutes.ago
  },
  {
    record_type: 'order',
    source_id: 101,
    data: {
      id: 101,
      user_id: 1,
      user_name: 'John Doe',
      user_email: 'john@example.com',
      product_name: 'Widget A',
      quantity: 2,
      price_cents: 1999,
      price_dollars: 19.99,
      total_cents: 3998,
      total_dollars: 39.98,
      created_at: '2024-12-11T11:00:00Z'
    },
    received_at: 45.minutes.ago,
    processed_at: nil
  },
  {
    record_type: 'order',
    source_id: 102,
    data: {
      id: 102,
      user_id: 2,
      user_name: 'Jane Smith',
      user_email: 'jane@example.com',
      product_name: 'Widget B',
      quantity: 1,
      price_cents: 2999,
      price_dollars: 29.99,
      total_cents: 2999,
      total_dollars: 29.99,
      created_at: '2024-12-11T11:30:00Z'
    },
    received_at: 15.minutes.ago,
    processed_at: nil
  }
]

sample_records.each do |record_data|
  ReceivedRecord.create!(record_data)
end

puts "Created #{ReceivedRecord.count} received records"
puts "- Users: #{ReceivedRecord.by_type('user').count}"
puts "- Orders: #{ReceivedRecord.by_type('order').count}"
puts "- Processed: #{ReceivedRecord.processed.count}"
puts "- Unprocessed: #{ReceivedRecord.unprocessed.count}"