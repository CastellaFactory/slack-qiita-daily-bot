require "./spec_helper"

describe QiitaDailyBot do
  json_url = "https://raw.githubusercontent.com/qaleidospace/qaleidospace.github.io/master/_data/daily.json"

  it "has a version number" do
    QiitaDailyBot::VERSION.should_not be_nil
  end

  it "get ranking data" do
    resp = HTTP::Client.get(json_url)
    result = Array(QiitaDailyBot::PostData).from_json(resp.body)
    (result.size > 0).should be_true
  end
end
