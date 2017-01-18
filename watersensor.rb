#!/usr/bin/ruby

#--------------------------
# watersensor.rb
# Author: a-yoshino
# Last Update: 2017/1/18
# Usage: ruby watersensor.rb
#--------------------------

require "open3"
require "net/http"
require "uri"
require "time"
require "json"
require 'base64'
require "yaml"

#----Load config file------
confFileName = "./config.yml"
config = YAML.load_file(confFileName)

# デバイスID (Cumulocityが払い出したID)
DEVICEID = config["deviceId"]
# CumulocityへのログインID
USERID = config["userId"]
# Cumulocityへのログインパスワード
PASSWD = config["password"]
# CumulocityのURL
URL = config["url"] + "/measurement/measurements/"
# WioNodeのアクセストークン
TOKEN = config["token"]
# センサ値の収集周期
INTERVAL = config["interval"]
#----------------------------

# WioNode接続用のURL
WIOURL = "https://us.wio.seeed.io/v1/node/GenericDInD0/input?access_token=" + TOKEN

# capture a water sensor value and sends it to cloud
loop do

# -------------------------------
# ここから水センサの値取得（GET）
# -------------------------------

  uri = URI.parse(WIOURL)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true # HTTPS通信を使用

  req = Net::HTTP::Get.new(uri.request_uri)

  res = https.request(req)

  isWater = JSON.parse(res.body)["input"].to_i

  case isWater
  when 0 then
    p "漏れてますからぁぁぁ！残念！！！"
  when 1 then
    p "安心してください、漏れてませんよ。"
  end

# -------------------------------
# ここからCloudへのPOST
# -------------------------------

  uri = URI.parse(URL)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true # HTTPS通信を使用

  req = Net::HTTP::Post.new(uri.request_uri)

  # Add HTTP request header
  req["Authorization"] = "Basic " + Base64.encode64(USERID + ":" + PASSWD).chomp
  req["Content-Type"] = "application/vnd.com.nsn.cumulocity.measurement+json; charset=UTF-8; ver=0.9"
  req["Accept"] = "application/vnd.com.nsn.cumulocity.measurement+json; charset=UTF-8; ver=0.9"


  # get current time
  time = Time.now.iso8601

  # make data body
  payload = {
    "waterSensor" => {
      "water" =>  { 
        "value" =>  isWater,
        "unit" =>  ""
        }
    },
    "time" =>  time, 
    "source" => {
      "id" => DEVICEID
    }, 
    "type" =>  "WaterSensor"

  }.to_json
 
  # send data
  req.body = payload 
  res = https.request(req)

  # confirm response data
  puts "code -> #{res.code} #{res.message}"
  puts "body -> #{res.body}"

  sleep(INTERVAL)

end




 
 

 

