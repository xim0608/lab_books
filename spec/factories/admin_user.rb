FactoryGirl.define do
  factory :admin_user do
    email 'foo@ijin.com'
    name '偉人太郎'
    nickname 'いじん'
    student_id '10000000'
    is_admin true
  end
end
