#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new("amqps://ncophwad:22UbesSSu5h5-TBy3xfBIJNbe_eQNRmb@shark.rmq.cloudamqp.com/ncophwad")
connection.start

channel = connection.create_channel
queue = channel.queue('task_queue', durable: true)

channel.prefetch(1)
puts ' [*] Waiting for messages. To exit press CTRL+C'

begin
  # block: true is only used to keep the main thread
  # alive. Please avoid using it in real world applications.
  queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
    puts " [x] Received '#{body}'"
    # imitate some work
    redis_fanout_tweet body
    puts ' [x] Done'
    channel.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  connection.close
end

def redis_fanout_tweet(query, tweet, user_id)
    query.each do |item|
        $redis.lpushx("timeline:user:#{item.follower_id}",tweet)
        $redis.ltrim("timeline:user:#{item.follower_id}", 0, 49)
    end
    $redis.del("user_partial:#{user_id}")
end