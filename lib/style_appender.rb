class StyleAppender
  def initialize(html)
    @html = html
    @styles = Nokogiri::HTML.parse(@html).search('style').children.to_html
  end

  def append(append_selector)
    styles = []
    tree = Crass.parse(@styles, preserve_comments: false)
    tree.each do |n|
      if n[:node] == :style_rule
        selector = n[:selector][:value]
        values_list = []
        n[:children].each do |child|
          if child[:node] == :property
            values_list.append("#{child[:name]}:#{child[:value]};")
          end
        end
        values = values_list.join(',')
        styles.append("#{append_selector} #{selector} { #{values} }")
      end
    end
    @styles = styles.join("\n")
  end

  def replace_style
    doc = Nokogiri::HTML.parse(@html)
    if doc.search('style').size > 1
      doc.search('style')[0..doc.search('style').size-2].remove
    end
    new_style = doc.create_element('style')
    new_style.set_attribute('type', 'text/css')
    new_style.inner_html = @styles
    doc.css('style').first.replace(new_style)
    doc.to_html
  end
end
