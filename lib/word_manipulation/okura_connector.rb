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
  end
end