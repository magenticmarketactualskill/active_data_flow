# Client App Seed Data

puts "Creating sample users and orders..."

# Create sample users
users = [
  { name: 'Alice Johnson', email: 'alice@example.com', age: 28 },
  { name: 'Bob Wilson', email: 'bob@example.com', age: 35 },
  { name: 'Carol Brown', email: 'carol@example.com', age: 42 },
  { name: 'David Lee', email: 'david@example.com', age: 31 }
]

created_users = users.map do |user_data|
  user = User.create!(user_data)
  
  # Create outgoing record for each user
  OutgoingRecord.create!(
    record_type: 'user',
    data: user.to_json_rpc_data,
    status: ['pending', 'sent', 'failed'].sample
  )
  
  user
end

puts "Created #{User.count} users"

# Create sample orders
orders_data = [
  { product_name: 'Laptop Pro', quantity: 1, price_cents: 129999 },
  { product_name: 'Wireless Mouse', quantity: 2, price_cents: 2999 },
  { product_name: 'USB Cable', quantity: 3, price_cents: 1499 },
  { product_name: 'Monitor Stand', quantity: 1, price_cents: 4999 },
  { product_name: 'Keyboard', quantity: 1, price_cents: 7999 },
  { product_name: 'Webcam', quantity: 1, price_cents: 8999 }
]

orders_data.each do |order_data|
  user = created_users.sample
  order = user.orders.create!(order_data)
  
  # Create outgoing record for each order
  OutgoingRecord.create!(
    record_type: 'order',
    data: order.to_json_rpc_data,
    status: ['pending', 'sent', 'failed'].sample
  )
end

puts "Created #{Order.count} orders"

# Create some additional outgoing records with different statuses
additional_records = [
  {
    record_type: 'user_update',
    data: { id: created_users.first.id, action: 'update', name: 'Alice Johnson Updated' },
    status: 'sent',
    sent_at: 1.hour.ago
  },
  {
    record_type: 'order_update',
    data: { id: Order.first.id, action: 'update', status: 'shipped' },
    status: 'failed',
    error_message: 'Connection timeout',
    retry_count: 2
  }
]

additional_records.each do |record_data|
  OutgoingRecord.create!(record_data)
end

puts "Created #{OutgoingRecord.count} outgoing records"
puts "- Pending: #{OutgoingRecord.pending.count}"
puts "- Sent: #{OutgoingRecord.sent.count}"
puts "- Failed: #{OutgoingRecord.failed.count}"