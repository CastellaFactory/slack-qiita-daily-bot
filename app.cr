require "../src/slack-qiita-daily-bot"
require "slack-incoming-webhooks"

# from QaleidoSpace repo(see. http://qiita.com/koher/items/b5c7c949aa62c60d5457)
json_url = "https://raw.githubusercontent.com/qaleidospace/qaleidospace.github.io/master/_data/daily.json"
qiita_url = "http://qiita.com/"

resp = HTTP::Client.get(json_url)
result = Array(QiitaDailyBot::PostData).from_json(resp.body)

slack = Slack::Incoming::Webhooks.new(
  ENV["WEBHOOK_URL"],
  username: "QiitaDaily (from Qaleidospace)")

attachments = Array(Slack::Incoming::Attachment).new

result.each do |data|
  attachment = Slack::Incoming::Attachment.new(
    author_name: data.user["id"],
    author_icon: data.user["profile_image_url"],
    author_link: "#{qiita_url}#{data.user["id"]}",
    title: "\##{data.rank} - #{data.title}",
    title_link: data.url
  )
  # Tag
  # data.tags [{"name" => "tag1"}, {"name" => "tag2"}, ...]
  tag_arr = data.tags.map { |hash| hash.first.at(1) }
  field = Slack::Incoming::AttachmentField.new(
    "タグ",
    tag_arr.join("  ")
  )
  attachment.add_field(field)

  attachments.push(attachment)
end

response = slack.post("", attachments: attachments)
puts response.body
