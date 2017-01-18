WaterSensor
====

Grove Water Sensorの値をWioNodeを使ってCumulocityに投稿するためのプログラムです。

# Description

このプログラムは[WioNode](https://www.seeedstudio.com/Wio-Node-p-2637.html)及び[Groveセンサ](https://www.seeedstudio.com/category/Grove-c-45.html)を活用するためのものです。  

このプログラムは以下の構成となっています。  

 - watersensor.rb : 水分センサの値を取得し、データポストするスクリプトです。
 - comfig-sample.yml : watersensor.rbを実行するために必要な設定情報を記載するファイルです。実際に使用する際にはconfig.ymlにリネームした上で設定値を記載して使ってください。

# Release Note

- 2017.1.18: version1.0

# Usage

 `$ ruby watersensor.rb`  

停止は **Ctrl + C** です。

# SetUp

## WioNodeの設定

参考：[WioNode Wiki](http://wiki.seeed.cc/Wio_Node/)  

Get Started の Step1〜Step4 を実行してください。  
Step4 については、Input > Generic Digital Input を選んでください。
  
## watersensorのダウンロード

Raspberry Pi上の任意のディレクトリで以下を実行します。  

`$ git clone https://github.com/iotfes/watersensor`

上記コマンドの結果、 **watersensor** ディレクトリができていれば成功。

## Author

Akiyuki YOSHINO
