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

  describe '#ja?' do
    it '日本語の文字に対してtrueを返す' do
      expect(unihan.ja?('これは日本語です')).to be true
    end

    it '中国語の文字に対してfalseを返す' do
      expect(unihan.ja?('这是中文')).to be false
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

    it '日本語を正しく識別する' do
      expect(unihan.determine_language('これは日本語です')).to eq('JA')
    end

    it '中国語や日本語を含まないテキストに対して"Unknown"を返す' do
      expect(unihan.determine_language('This is English')).to eq('Unknown')
    end
  end
end
