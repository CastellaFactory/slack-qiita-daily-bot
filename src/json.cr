require "json"
require "http/client"

module Response
  class PostData
    JSON.mapping({
      user:       Hash(String, String),
      url:        String,
      tags:       Array(Hash(String, String)),
      title:      String,
      created_at: String,
      score:      String,
      id:         String,
      rank:       Int32,
    })
  end
end

url = "https://raw.githubusercontent.com/qaleidospace/qaleidospace.github.io/master/_data/daily.json"

resp = HTTP::Client.get(url)
result = Array(Response::PostData).from_json(resp.body)

result.each do |post|
  printf("\#%s - %s(%s)\n%s(%s)\n%s\n", post.rank, post.title, post.url, post.user["id"], post.user["profile_image_url"], (post.tags))
end

# p %w(daily weekly yearly)[0]
# p %w(daily weekly yearly)[1]
# p %w(daily weekly yearly)[2]
