class Authorization < ActiveRecord::Base
  #attr_accessible :provider, :uid, :user_id
  belongs_to :user
  
	def self.find_or_create(auth_hash)
		auth = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
	  unless auth
	  	uth = self.create_social_user(auth_hash["info"], auth_hash['credentials'], auth_hash["provider"], auth_hash["uid"])
	  else
	  	auth = self.update_social_user(auth, auth_hash["info"], auth_hash['credentials'])
	  end
	  auth
	end
	
	def self.create_social_user(auth_hash, credentials, provider, uid)
		#user
		new_pass = SecureRandom.hex(5)
    usr = User.create(:username => auth_hash["name"],
                      :email => auth_hash["email"],
                      :first_name => auth_hash["first_name"],
                      :last_name => auth_hash["last_name"],
                      :password => new_pass,
                      :password_confirmation => new_pass)
    usr.save(:validate => false)
    #role		
    usr.role = Role.find_by_role_type("User")
    #authorization
    auth = create :user_id => usr.id,
    							:provider => provider,
    							:uid => uid, 
    							:token => credentials['token'], 
    							:secret => credentials['secret'], 
    							:screen_name => auth_hash['name']
    auth.save							    
    return auth
	end
	
	def self.update_social_user(auth, auth_hash, credentials)
  	#authoraization
  	auth.token = credentials['token']
  	auth.secret = credentials['secret']
  	auth.screen_name = auth_hash["name"]
  	auth.save
  	return auth
	end	
end
