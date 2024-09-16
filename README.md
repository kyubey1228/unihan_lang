<!-- @format -->

# UnihanLang

`unihan_lang` is a Ruby library for identifying text language (Traditional Chinese, Simplified Chinese) and performing various checks on Chinese characters.

This document can also be read in [Japanese](https://github.com/kyubey1228/unihan_lang/blob/master/README.ja.md).

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
puts unihan.determine_language("這是繁體中文") # => "ZH_TW"
puts unihan.determine_language("这是简体中文") # => "ZH_CN"

# Check if text is Traditional Chinese
puts unihan.zh_tw?("這是繁體中文") # => true
puts unihan.zh_tw?("这不是繁体中文") # => false

# Check if text is Simplified Chinese
puts unihan.zh_cn?("这是简体中文") # => true
puts unihan.zh_cn?("這不是簡體中文") # => false

# Check if text contains Chinese characters
puts unihan.contains_chinese?("This text contains 中文") # => true
puts unihan.contains_chinese?("This text has no Chinese") # => false

# Extract Chinese characters from text
puts unihan.extract_chinese_characters("This text contains 中文").join # => "中文"

# Check if text consists only of Traditional Chinese characters
puts unihan.only_zh_tw?("繁體") # => true
puts unihan.only_zh_tw?("繁體简体") # => false

# Check if text consists only of Simplified Chinese characters
puts unihan.only_zh_cn?("简体") # => true
puts unihan.only_zh_cn?("简体繁體") # => false

# Check if text contains Traditional Chinese characters
puts unihan.contains_zh_tw?("這個text包含繁體字") # => true
puts unihan.contains_zh_tw?("这个text不包含繁体字") # => false

# Check if text contains Simplified Chinese characters
puts unihan.contains_zh_cn?("这个text包含简体字") # => true
puts unihan.contains_zh_cn?("這個text不包含簡體字") # => false
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
