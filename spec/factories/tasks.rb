FactoryGirl.define do
  factory :task do
    user nil
    title "MyString"
    content "MyText"
    deadline "2016-05-27 15:43:33"
    charge_id 1
    done false
    status 1
  end
end
