# list pulled from redit https://www.reddit.com/r/ruby/comments/16zu7vy/good_books/
["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
    Book.find_or_create_by!(title: "Learn to Program", author: "Chris Pine")
    Book.find_or_create_by!(title: "Eloquent Ruby", author: "Russ Olsen")
    Book.find_or_create_by!(title: "Programming Ruby", author: "Dave Thomas")
end