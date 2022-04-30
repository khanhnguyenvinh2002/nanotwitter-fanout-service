
def redis_fanout_tweet(query, tweet, user_id)
    query.each do |item|
        $redis.lpushx("timeline:user:#{item["follower_id"]}",tweet.to_json)
        $redis.ltrim("timeline:user:#{item["follower_id"]}", 0, 49)
    end
    $redis.del("user_partial:#{user_id}")
end