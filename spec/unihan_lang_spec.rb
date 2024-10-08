# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UnihanLang::Unihan do
  let(:unihan) { UnihanLang::Unihan.new }

  describe '#zh_tw?' do
    it '繁体字中国語の文字に対してtrueを返す' do
      expect(unihan.zh_tw?('繁體中文')).to be true
    end

    it '簡体字中国語の文字に対してfalseを返す' do
      expect(unihan.zh_tw?('简体中文')).to be false
    end
  end

  describe '#zh_cn?' do
    it '簡体字中国語の文字に対してtrueを返す' do
      expect(unihan.zh_cn?('简体中文')).to be true
    end

    it '繁体字中国語の文字に対してfalseを返す' do
      expect(unihan.zh_cn?('繁體中文')).to be false
    end
  end

  describe '#contains_chinese?' do
    it '中国語の文字を含むテキストに対してtrueを返す' do
      expect(unihan.contains_chinese?('This text contains 中文')).to be true
    end

    it '中国語の文字を含まないテキストに対してfalseを返す' do
      expect(unihan.contains_chinese?('This text does not contain Chinese')).to be false
    end
  end

  describe '#extract_chinese_characters' do
    it '混合テキストから中国語の文字を抽出する' do
      expect(unihan.extract_chinese_characters('This text contains 中文')).to eq(%w[中 文])
    end

    it '中国語の文字を含まないテキストに対して空の配列を返す' do
      expect(unihan.extract_chinese_characters('This text does not contain Chinese')).to be_empty
    end
  end

  describe '#determine_language' do
    it '繁体字中国語を正しく識別する' do
      expect(unihan.determine_language('這是繁體中文')).to eq('ZH_TW')
    end

    it '簡体字中国語を正しく識別する' do
      expect(unihan.determine_language('这是简体中文')).to eq('ZH_CN')
    end

    it '中国語や日本語を含まないテキストに対して"Unknown"を返す' do
      expect(unihan.determine_language('This is English')).to eq('Unknown')
    end
  end

  describe '#only_zh_tw?' do
    it '繁体字のみで構成されたテキストに対してtrueを返す' do
      # U+9AD4	kSimplifiedVariant	U+4F53
      expect(unihan.only_zh_tw?('體')).to be true
    end

    it '簡体字を含むテキストに対してfalseを返す' do
      expect(unihan.only_zh_tw?('繁體简体')).to be false
    end

    it '共通の字を含むテキストに対してfalseを返す' do
      expect(unihan.only_zh_tw?('繁體中文')).to be false
    end

    it 'same codes point both zh_tw and zh_cn in Unihan_Variants.txt returns false' do
      # U+53F0	kSimplifiedVariant	U+53F0
      # U+53F0	kTraditionalVariant	U+53F0 U+6AAF U+81FA U+98B1
      expect(unihan.only_zh_tw?('台')).to be false
    end
  end

  describe '#only_zh_cn?' do
    it '簡体字のみで構成されたテキストに対してtrueを返す' do
      # U+3437	kTraditionalVariant	U+508C
      expect(unihan.only_zh_cn?('㐷')).to be true
    end

    it '繁体字を含むテキストに対してfalseを返す' do
      expect(unihan.only_zh_cn?('简体繁體')).to be false
    end

    it '共通の字を含むテキストに対してfalseを返す' do
      expect(unihan.only_zh_cn?('简体中文')).to be false
    end

    it 'same code points both zh_tw and zh_cn in Unihan_Variants.txt returns false' do
      # U+53F0	kSimplifiedVariant	U+53F0
      # U+53F0	kTraditionalVariant	U+53F0 U+6AAF U+81FA U+98B1
      expect(unihan.only_zh_cn?('台')).to be false
    end
  end

  describe '#contains_zh_tw?' do
    it '繁体字を含むテキストに対してtrueを返す' do
      expect(unihan.contains_zh_tw?('這個text包含繁體字')).to be true
    end

    it '繁体字を含まないテキストに対してfalseを返す' do
      expect(unihan.contains_zh_tw?('这个text不包含简体字')).to be false
    end

    it '共通の漢字のみを含むテキストに対してfalseを返す' do
      expect(unihan.contains_zh_tw?('中文')).to be false
    end
  end

  describe '#contains_zh_cn?' do
    it '簡体字を含むテキストに対してtrueを返す' do
      expect(unihan.contains_zh_cn?('这个text包含简体字')).to be true
    end

    it '簡体字を含まないテキストに対してfalseを返す' do
      expect(unihan.contains_zh_cn?('這個text不包含簡體字')).to be false
    end
  end
end
