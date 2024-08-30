# UnihanLang

UnihanLang は、テキストの言語（日本語、繁体字中国語、簡体字中国語）を識別するための Ruby ライブラリです。

## インストール

Gemfile に以下の行を追加してください：

```ruby
gem 'unihan_lang'
```

そして、以下のコマンドを実行してください：

```sh
bundle install
```

または、直接インストールする場合は以下のコマンドを使用してください：

```sh
gem install unihan_lang
```

## 使用方法

```ruby
require 'unihan_lang'

unihan = UnihanLang::Unihan.new

# 言語の判定
puts unihan.determine_language("これは日本語です")  # => "JA"
puts unihan.determine_language("這是繁體中文")      # => "ZH_TW"
puts unihan.determine_language("这是简体中文")      # => "ZH_CN"

# 日本語かどうかの判定
puts unihan.ja?("これは日本語です")  # => true
puts unihan.ja?("这不是日语")        # => false

# 繁体字中国語かどうかの判定
puts unihan.zh_tw?("這是繁體中文")  # => true
puts unihan.zh_tw?("这不是繁体中文")  # => false

# 簡体字中国語かどうかの判定
puts unihan.zh_cn?("这是简体中文")  # => true
puts unihan.zh_cn?("這不是簡體中文")  # => false

# テキストに中国語の文字が含まれているかの判定
puts unihan.contains_chinese?("This text contains 中文")  # => true
puts unihan.contains_chinese?("This text has no Chinese")  # => false

# テキストから中国語の文字を抽出
puts unihan.extract_chinese_characters("This text contains 中文").join  # => "中文"
```

## 注意事項

このライブラリは、テキストの言語を完全に正確に判定することを保証するものではありません。
特に、短いテキストや複数の言語が混在するテキストの場合、判定が難しい場合があります。

### 例えば

`東京` や `日本語` といった単語は日本語と判定されないため誰か直してください。
