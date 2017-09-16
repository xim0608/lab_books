require 'okura/serializer'

module WordManipulation
  class OkuraConnector
    def initialize
      @dict_dir = "#{Rails.root}/lib/word_manipulation/okura-dic"
      @tagger = Okura::Serializer::FormatInfo.create_tagger @dict_dir
      puts "success"
    end

    def is_noun?(str)
      if str.ascii_only?
        true
      else
        nodes = @tagger.parse(str)
        result = ''
        nodes.mincost_path.each_with_index do |node, idx|
          if idx == nodes.mincost_path.size - 1 || idx == 0
            next
          end
          word = node.word
          result = word.left.text.split(',')[0]
          if result != '名詞'
            return false
          end
        end
        true
      end
    end

    def select_nouns(str)
      nouns = []
      nodes = @tagger.parse(str)
      nodes.mincost_path.each do |node|
        word = node.word
        # p word.surface # 単語の表記
        # p word.left.text # 品詞
        if word.left.text.split(',')[0] == '名詞'
          nouns.append(word.surface)
        end
        # 品詞はword.leftとword.rightがありますが､一般的に使われる辞書(IPA辞書やNAIST辞書)では
        # 両方同じデータが入ってます

      end
      # p nouns
      nouns.join(' ')
    end
  end
end