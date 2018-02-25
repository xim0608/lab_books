FactoryGirl.define do
  factory :user do
    email 'foo@bar.com'
    name '田中太郎'
    nickname 'たろう'
    student_id '10000000'
    year 'B3'
    is_admin true
  end
end