require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext/string'

class TrueClass
  def yesno
    "Yes"
  end
end

class FalseClass
  def yesno
    "No"
  end
end

ocw_url = 'http://ocw.mit.edu'
course_list = Nokogiri::HTML(open('http://ocw.mit.edu/courses/'))
courses = Hash.new
all_features = Array.new
count = 0
course_list.css('table.courseList').each do |category|
    break if count == 3
    count = count + 1
    
    category.css('tbody').css('tr').each do |course|
        fields = course.css('td a')

        id = "#{fields[0].text.squish}_#{rand(1024).to_s(16)}"
        url = fields[1]['href'].squish
        title = fields[1].text.squish.tr(',', '')
        level = fields[2].text.squish.tr(',', '')
        features = []
        
        
        course_page = Nokogiri::HTML(open("http://ocw.mit.edu#{url}"))
        instructor = course_page.css('p.ins').text.squish.tr(',', '')
        course_page.css('ul.specialfeatures').css('li').each do |feature|
          feature_clean = feature.text.squish.downcase.tr(',', '')
          features << feature_clean
          all_features << feature_clean
        end
        next if features.empty?
        courses[id] = {:url => url, :title => title, :level => level, :instructor => instructor, :features => features}
        
    end

end
all_features.uniq!
puts "id, department, title, instructor, url, level, #{all_features.join(', ')}"
courses.each do |id, info|
  course = "#{id}, #{info[:url].split('/').drop(2).first.titleize}, #{info[:title]}, #{info[:instructor]}, http://ocw.mit.edu#{info[:url]}, #{info[:level]}"
  
  all_features.each do |feature|
      has_feature = info[:features].include?(feature)
      course << ", #{has_feature.yesno}"
  end
  puts course
    
end