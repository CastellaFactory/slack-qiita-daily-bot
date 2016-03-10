require "./spec_helper"

describe Slack::Qiita::Daily::Bot do
  it "Get JSON" do
    resp = HTTP::Client.get("https://raw.githubusercontent.com/qaleidospace/qaleidospace.github.io/master/_data/daily.json")
    result = Array(Slack::Qiita::Daily::Bot::PostData).from_json(resp.body)
    (result.size > 0).should be_true
  end
end
