require "../src/slack-qiita-daily-bot"
require "slack-incoming-webhooks"

# from QaleidoSpace repo(see. http://qiita.com/koher/items/b5c7c949aa62c60d5457)
json_url = "https://raw.githubusercontent.com/qaleidospace/qaleidospace.github.io/master/_data/daily.json"
qiita_url = "http://qiita.com/"

resp = HTTP::Client.get(json_url)
result = Array(Slack::Qiita::Daily::Bot::PostData).from_json(resp.body)

slack = Slack::Incoming::Webhooks::Hook.new(
  ENV["WEBHOOK_URL"],
  username: "QiitaDaily (from Qaleidospace)")

attachments = Array(Slack::Incoming::Webhooks::Attachment).new

result.each do |data|
  attachment = Slack::Incoming::Webhooks::Attachment.new(
    author_name: data.user["id"],
    author_icon: data.user["profile_image_url"],
    author_link: "#{qiita_url}#{data.user["id"]}",
    title: "\##{data.rank} - #{data.title}",
    title_link: data.url
  )
  # Tag
  tag_arr = [] of String
  data.tags.each do |hash|
    tag_arr.push hash.map { |k, v| v }.join
  end
  field = Slack::Incoming::Webhooks::AttachmentField.new(
    "タグ",
    tag_arr.join("  ")
  )
  attachment.add_field(field)
  attachments.push(attachment)
end

response = slack.post("", attachments: attachments)
puts response.body
