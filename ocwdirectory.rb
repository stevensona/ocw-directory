require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext/string'
require 'csv'

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
    #break if count == 1
    puts count
    count = count + 1

    category.css('tbody').css('tr').each do |course|
        fields = course.css('td a')

        id = "#{fields[0].text.squish}_#{rand(1024).to_s(16)}"
        url = fields[1]['href'].squish
        title = fields[1].text.squish
        level = fields[2].text.squish
        features = []


        course_page = Nokogiri::HTML(open("http://ocw.mit.edu#{url}"))
        instructor = course_page.css('p.ins').text.squish
        course_page.css('ul.specialfeatures').css('li').each do |feature|
          feature_clean = feature.text.squish.downcase
          features << feature_clean
          all_features << feature_clean
        end
        next if features.empty?
        courses[id] = {:url => url, :title => title, :level => level, :instructor => instructor, :features => features}

    end

end
all_features.uniq!
CSV.open(ARGV.shift, 'wb') do |csv|
  csv << ['id', 'department', 'title', 'instructor', 'url', 'level'] + all_features
  courses.each do |id, info|
    row = [id, info[:url].split('/').drop(2).first.titleize, info[:title], info[:instructor], "<a href=\"http://ocw.mit.edu#{info[:url]}\">Course Page</a>", info[:level]]
    all_features.each do |feature|
        has_feature = info[:features].include?(feature)
        row << has_feature.yesno
    end
    csv << row
  end
end
