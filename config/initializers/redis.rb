
uri = URI.parse("redis://redistogo:6cc5624737c2399dce4975d832884dc0@sole.redistogo.com:10369/")
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
# $redis = Redis.new(url: "redis://redistogo:6cc5624737c2399dce4975d832884dc0@sole.redistogo.com:10369/")
$maxRecentNum=50