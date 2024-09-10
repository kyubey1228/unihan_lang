<!-- @format -->

# UnihanLang

UnihanLang は、テキストの言語（繁体字中国語、簡体字中国語）を識別し、中国語の文字に関する様々な判定を行うための Ruby ライブラリです。

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
puts unihan.determine_language("這是繁體中文")      # => "ZH_TW"
puts unihan.determine_language("这是简体中文")      # => "ZH_CN"

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

# 繁体字のみで構成されているかの判定
puts unihan.only_zh_tw?("繁體")  # => true
puts unihan.only_zh_tw?("繁體简体")  # => false

# 簡体字のみで構成されているかの判定
puts unihan.only_zh_cn?("简体")  # => true
puts unihan.only_zh_cn?("简体繁體")  # => false

# 繁体字を含むかどうかの判定
puts unihan.contains_zh_tw?("這個text包含繁體字")  # => true
puts unihan.contains_zh_tw?("这个text不包含繁体字")  # => false

# 簡体字を含むかどうかの判定
puts unihan.contains_zh_cn?("这个text包含简体字")  # => true
puts unihan.contains_zh_cn?("這個text不包含簡體字")  # => false
```

## 機能説明

- `determine_language(text)`: テキストの言語を判定します（"ZH_TW", "ZH_CN", "Unknown"）。
- `zh_tw?(text)`: テキストが繁体字中国語かどうかを判定します。
- `zh_cn?(text)`: テキストが簡体字中国語かどうかを判定します。
- `contains_chinese?(text)`: テキストに中国語の文字が含まれているかを判定します。
- `extract_chinese_characters(text)`: テキストから中国語の文字を抽出します。
- `only_zh_tw?(text)`: テキストが繁体字のみで構成されているかを判定します。
- `only_zh_cn?(text)`: テキストが簡体字のみで構成されているかを判定します。
- `contains_zh_tw?(text)`: テキストに繁体字が含まれているかを判定します。
- `contains_zh_cn?(text)`: テキストに簡体字が含まれているかを判定します。

## 注意事項

このライブラリは、テキストの言語を完全に正確に判定することを保証するものではありません。
特に、短いテキストや複数の言語が混在するテキストの場合、判定が難しい場合があります。

## =========================

# UnihanLang

UnihanLang is a Ruby library for identifying text language (Traditional Chinese, Simplified Chinese) and performing various checks on Chinese characters.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unihan_lang'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install unihan_lang
```

## Usage

```ruby
require 'unihan_lang'

unihan = UnihanLang::Unihan.new

# Language determination
puts unihan.determine_language("這是繁體中文")      # => "ZH_TW"
puts unihan.determine_language("这是简体中文")      # => "ZH_CN"

# Check if text is Traditional Chinese
puts unihan.zh_tw?("這是繁體中文")  # => true
puts unihan.zh_tw?("这不是繁体中文")  # => false

# Check if text is Simplified Chinese
puts unihan.zh_cn?("这是简体中文")  # => true
puts unihan.zh_cn?("這不是簡體中文")  # => false

# Check if text contains Chinese characters
puts unihan.contains_chinese?("This text contains 中文")  # => true
puts unihan.contains_chinese?("This text has no Chinese")  # => false

# Extract Chinese characters from text
puts unihan.extract_chinese_characters("This text contains 中文").join  # => "中文"

# Check if text consists only of Traditional Chinese characters
puts unihan.only_zh_tw?("繁體")  # => true
puts unihan.only_zh_tw?("繁體简体")  # => false

# Check if text consists only of Simplified Chinese characters
puts unihan.only_zh_cn?("简体")  # => true
puts unihan.only_zh_cn?("简体繁體")  # => false

# Check if text contains Traditional Chinese characters
puts unihan.contains_zh_tw?("這個text包含繁體字")  # => true
puts unihan.contains_zh_tw?("这个text不包含繁体字")  # => false

# Check if text contains Simplified Chinese characters
puts unihan.contains_zh_cn?("这个text包含简体字")  # => true
puts unihan.contains_zh_cn?("這個text不包含簡體字")  # => false
```

## Features

- `determine_language(text)`: Determines the language of the text ("ZH_TW", "ZH_CN", "JA", "Unknown").
- `zh_tw?(text)`: Checks if the text is in Traditional Chinese.
- `zh_cn?(text)`: Checks if the text is in Simplified Chinese.
- `contains_chinese?(text)`: Checks if the text contains Chinese characters.
- `extract_chinese_characters(text)`: Extracts Chinese characters from the text.
- `only_zh_tw?(text)`: Checks if the text consists only of Traditional Chinese characters.
- `only_zh_cn?(text)`: Checks if the text consists only of Simplified Chinese characters.
- `contains_zh_tw?(text)`: Checks if the text contains Traditional Chinese characters.
- `contains_zh_cn?(text)`: Checks if the text contains Simplified Chinese characters.

## Note

This library does not guarantee 100% accuracy in language identification.
Particularly for short texts or texts containing multiple languages, determination may be challenging.
The distinction between Traditional and Simplified Chinese is based on the Unihan database.
