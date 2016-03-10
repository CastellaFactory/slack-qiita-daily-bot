require "./slack-qiita-daily-bot2/*"

require "json"
require "http/client"

module Slack::Qiita::Daily::Bot2
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
