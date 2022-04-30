#!/usr/bin/env ruby
require 'bunny'
require 'json'
connection = Bunny.new("amqps://ncophwad:22UbesSSu5h5-TBy3xfBIJNbe_eQNRmb@shark.rmq.cloudamqp.com/ncophwad")
connection.start

channel = connection.create_channel
queue = channel.queue('test', durable: true)

channel.prefetch(1)
puts ' [*] Waiting for messages. To exit press CTRL+C'

begin
  # block: true is only used to keep the main thread
  # alive. Please avoid using it in real world applications.
  queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
    answer = JSON.parse(body)
    query = answer["query"]
    tweet = answer["tweet"]
    user_id = answer["user_id"]
    puts " [x] Received '#{query}'"
    puts " [x] Received '#{user_id}'"
    puts " [x] Received '#{tweet}'"
    # imitate some work
    redis_fanout_tweet(query, tweet, user_id)
    puts ' [x] Done'
    channel.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  connection.close
end

def redis_fanout_tweet(query, tweet, user_id)
    query.each do |item|
        $redis.lpushx("timeline:user:#{item["follower_id"]}",tweet.to_json)
        $redis.ltrim("timeline:user:#{item["follower_id"]}", 0, 49)
    end
    $redis.del("user_partial:#{user_id}")
end