$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'unihan_lang'

unihan = UnihanLang::Unihan.new

test_cases = [
  "繁體字",
  "简体字",
  "日本語",
  "中文",
  "漢字",
  "汉字",
  "東京",
  "北京",
  "台北",
  "ひらがな",
  "カタカナ",
  "漢字とひらがな",
  "こんにちは世界",
  "你好世界",
  "你好世界",
  "實際的例子",
  "实际的例子",
  "現実の例"
]

test_cases.each do |word|
  puts "\nTesting '#{word}':"
  puts "zh_tw?: #{unihan.zh_tw?(word)}"
  puts "zh_cn?: #{unihan.zh_cn?(word)}"
  puts "ja?: #{unihan.ja?(word)}"
  puts "Language: #{unihan.determine_language(word)}"
  puts "Character details:"
  word.each_char do |char|
    print "#{char}: "
    chinese_processor = unihan.instance_variable_get(:@chinese_processor)
    japanese_processor = unihan.instance_variable_get(:@japanese_processor)
    in_zh_tw = chinese_processor.zh_tw.include?(char)
    in_zh_cn = chinese_processor.zh_cn.include?(char)
    in_common = chinese_processor.common.include?(char)
    is_chinese = chinese_processor.is_chinese?(char)
    is_japanese = japanese_processor.is_japanese?(char.to_s)
    is_kana = char =~ /[\p{Hiragana}\p{Katakana}ー]/
    print "ZH_TW " if in_zh_tw
    print "ZH_CN " if in_zh_cn
    print "Common " if in_common
    print "Chinese " if is_chinese
    print "Japanese " if is_japanese
    print "KANA " if is_kana
    print "UNKNOWN" if !in_zh_tw && !in_zh_cn && !in_common && !is_chinese && !is_japanese && !is_kana
    puts
  end
end
