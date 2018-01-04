namespace :content_based_recommend do
  desc 'book_idからレコメンドさせる(計算初期化)'
  task :generate => :environment do
    ContentBasedRecommend::LabooksRecommend.set_recommends
  end
end
