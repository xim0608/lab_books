require 'csv'

p "started to set books"
csv_dir = Dir.glob(File.join(Rails.root, 'db', 'seeds', 'booklog*')).last

counter = 0
File.open(csv_dir, 'r') do |file|
  p file.path
  counter = Book.import(file)
end
p "#{counter} books were inserted"
