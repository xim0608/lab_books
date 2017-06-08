module BooksHelper
  def cut_description(description)
    if description.length > 80
      str = description.slice!(0,80)
      str += '...'
    end
    str
  end
end