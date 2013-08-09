task :facebook_likes do
  Rake::Task["facebook_likes"].invoke
end

task :facebook_likes => :environment do
    
    url_contents = UrlContent.where("is_facebook_shared AND facebook_post_id IS NOT NULL", true)
    
    url_contents.each do |u|
      token = u.user_url.user.authorization.token
      uri = URI("https://graph.facebook.com/#{u.facebook_post_id}/likes?access_token=#{token}")
      data = Net::HTTP.get(uri)
      data = JSON.parse(data)['data']
      puts u.facebook_post_id
      puts '================================'
      puts "likes = #{data.size}"
      u.facebook_likes_count = data.size
      u.save
    end 
    
    puts "End - facebook likes"
end

