FactoryGirl.define do

  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password  "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end


  factory :history do 
     sequence(:title) { |n| "history #{n}" }
     description "not approved"
     user

     factory :approved_history do
      approved true
     end
  end

  factory :event do 
     sequence(:title) { |n| "event #{n}" }
     start "2014-09-15 02:09:05.412232"
     place "paris"
     user

     factory :approved_event do
      approved true
     end
  end

  factory :history_simple, :class  => 'History' do 
     title  "not approved" 
     description "history simple"
     user
  end


  factory :event_simple, :class  => 'Event' do 
     title  "not approved"   
     start "2014-09-15 02:09:05.412232"
     place "paris"
     user
  end



end
