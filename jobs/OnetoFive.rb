require('sinatra')
require('sinatra/reloader')
require('firebase')
require('open-uri')
require('json')
require('pp')
require('date')
require('rufus-scheduler')
require('rspec')
# require('nokogiri')

base_uri = 'https://whawksv2.firebaseio.com'

@firebase = Firebase::Client.new(base_uri)

scheduler = Rufus::Scheduler.new



@d = Date.parse(Time.now.getlocal('-08:00').to_s)
@url = 'http://cluster.leaguestat.com/feed/index.php?feed=dayview&key=2f98c793394f0ef3&client_code=whl&date=' + @d.to_s
scheduler.every '40s' do
	@d = Date.parse(Time.now.getlocal('-08:00').to_s)
	(@d >> 1).strftime("%d/%m/%Y %H:%M")
	@url = 'http://cluster.leaguestat.com/feed/index.php?feed=dayview&key=2f98c793394f0ef3&client_code=whl&date=' + @d.to_s
end 
   # url = 'http://cluster.leaguestat.com/feed/index.php?feed=dayview&key=2f98c793394f0ef3&client_code=whl&date=2015-11-11'
 @whscheduleurl = "http://cluster.leaguestat.com/feed/index.php?feed=xmlkit&key=2f98c793394f0ef3&client_code=whl&view=schedule&team_id=208"

@badwords = ['ahole','anus','ash0le','ash0les','asholes','ass','assmonkey','assface','assh0le','assh0lez','asshole','asshole','assholes','assholz','asswipe','azzhole','bassterds','bastard','bastards','bastardz','basterds','basterdz','biatch','bitch','bitches','blowjob','boffing','butthole','buttwipe','c0ck','c0cks','c0k','carpetmuncher','cawk','cawks','clit','cnts','cntz','cock','cockhead','cockhead','cocks','cocksucker','cocksucker','crap','cum','cunt','cunts','cuntz','dick','dild0','dild0s','dildo','dildos','dilld0','dilld0s','dominatricks','dominatrics','dominatrix','dyke','enema','fag','fag1t','faget','fagg1t','faggit','faggot','fagit','fags','fagz','faig','faigs','fart','fuck','fucker','fuckin','fucking','fucks','fudgepacker','fuk','fukah','fuken','fuker','fukin','fukk','fukkah','fukken','fukker','fukkin','g00k','gay','gaybor','gayboy','gaygirl','gays','gayz','goddamned','h00r','h0ar','h0re','hells','hoar','hoor','hoore','jackoff','jap','japs','jerkoff','jisim','jiss','jizm','jizz','knob','knobs','knobz','kunt','kunts','kuntz','lesbian','lezzian','lipshits','lipshitz','masochist','masokist','massterbait','masstrbait','masstrbate','masterbaiter','masterbate','masterbates','mutha','fuker','motha','fucker','fuker','fukka','fukkah','fucka','fuchah','fukker','fukah','mothafucker','mothafuker','mothafukkah','mothafukker','motherfucker','motherfukah','motherfuker','motherfukkah','motherfukker','motherfucker','muthafucker','muthafukah','muthafuker','muthafukkah','muthafukker','mutha','n1gr','nastt','nasty','nigger','nigur','niiger','niigr','orafis','orgasim','orgasm','orgasum','oriface','orifice','orifiss','packi','packie','packy','paki','pakie','paky','pecker','peeenus','peeenusss','peenus','peinus','pen1s','penas','penis','penisbreath','penus','penuus','phuc','phuck','phuk','phuker','phukker','polac','polack','polak','poonani','pr1c','pr1ck','pr1k','pusse','pussee','pussy','puuke','puuker','queer','queers','queerz','qweers','qweerz','qweir','recktum','rectum','retard','sadist','scank','schlong','screwing','semen','sex','sexx','sexxx','sx','sexy','sht','sh1t','sh1ter','sh1ts','sh1tter','sh1tz','shit','shits','shitter','shitty','shity','shitz','shyt','shyte','shytty','shyt','skanck','skank','skankee','skankey','skanks','skanky','slut','sluts','slutty','slutz','sonofabitch','tit','turd','va1jina','vag1na','vagiina','vagina','vaj1na','vajina','vullva','vulva','w0p','wh00r','wh0re','whore','xrated','xxx','bch','bitch','blowjob','clit','arschloch','fuck','shit','ass','asshole','btch','b17ch','b1tch','bastard','bich','boiolas','buceta','c0ck','cawk','chink','cipa','clits','cock','cum','cunt','dildo','dirsa','ejakulate','fatass','fcuk','fuk','fux0r','hoer','hore','jism','kawk','l3itch','l3i+ch','lesbian','masturbate','masterbat','masterbat3','motherfucker','s.o.b.','mofo','nazi','nigga','nigger','nutsack','phuck','pimpis','pusse','pussy','scrotum','shemale','shi+','shitt','slut','smut','teets','tits','boobs','b00bs','teez','testical','testicle','titt','w00se','jackoff','wank','whoar','whore','damn','dyke','fuck','shit','@$$','amcik','andskota','arse','assrammer','ayir','bi7ch','bitch','bollock','breasts','buttpirate','cabron','cazzo','chraa','chuj','cock','cunt','d4mn','daygo','dego','dick','dike','dupa','dziwka','ejackulate','ekrem','ekto','enculer','faen','fag','fanculo','fanny','feces','feg','felcher','ficken','fitt','flikker','foreskin','fotze','fu','fuk','futkretzn','gay','gook','guiena','h0r','h4x0r','hell','helvete','hoer','honkey','huevon','hui','injun','jizz','kanker','kike','klootzak','kraut','knulle','kuk','kuksuger','kurac','kurwa','kusi','kyrpa','lesbo','mamhoon','masturbat','merd','mibun','monkleigh','mouliewop','muie','mulkku','muschi','nazis','nepesaurio','nigger','orospu','paska','perse','picka','pierdol','pillu','pimmel','piss','pizda','poontsee','poop','porn','p0rn','pr0n','preteen','pula','pule','puta','puto','qahbeh','queef','rautenberg',"schaffer","scheiss","schlampe","schmuck","screw","sharmuta","sharmute","shipal","shiz","skrib"];
@exceptions = ["sassy", "hello", "nathandickie", "widmerdude", "jeffglass", "scrap.nstampgrl", "mmarcummt", "hello.kaity77", "sassyj96", "shellbell278"]

fakeArray = []
 def cleanFirebase (firebaseInstance)
 	response = @firebase.get(firebaseInstance)
  responseBody = response.raw_body
  responseJson = JSON.parse(responseBody)
  return responseJson
 end
 
 def getUserNames(peopleArray)
 	userNames = cleanFirebase('uidToUsername')
 	count = 0
 	peopleArray.each do |player|
 		count = count + 1
 		userNames.each do |uid|
 			if (player[0] === uid[0])
 				player[0] = (uid[1].values)[0].downcase
 				@badwords.each do |word|
 						if (player[0].include?(word.downcase))
 							if(@exceptions.include?(player[0]))
 								puts "Exception " + player[0]
 							else
 								player[0] = player[0].gsub!(word.downcase, "****")
 							end
 						end
 					end
 				if player[0].length > 10
 					player[0] = player[0][0..9]
 				end
 			end
 			#player[2] = "(" + count.to_s + ")"
			player[1] = player[1].to_s
 		end
 	end
 	return peopleArray.take(10)
 end
def getSortedUsers()
	 currentPoints = cleanFirebase('currentGameUserPoints')
	 sortedCurrentPoints = currentPoints.sort_by { |key, value| value }.reverse!
	 @sortedUsersPoints = getUserNames(sortedCurrentPoints)
	 return @sortedUsersPoints
end



scheduler.every '5s' do
	buzzword_counts = Hash.new({ value: 0 })
	buzzword_topOne = Hash.new({ value: 0 })
	i = 1
	fakeArray = getSortedUsers()
	buzzword_topOne[fakeArray[0]] = { label: fakeArray[0][0], value: fakeArray[0][1] }
	while i < fakeArray.length - 5 ;

 		buzzword_counts[fakeArray[i]] = { label: fakeArray[i][0], value: fakeArray[i][1] }
  		# puts buzzword_counts[Top5Players[i]].values
 		i += 1
	end
	send_event('OnetoFive', { items: buzzword_counts.values })
	send_event('Top1', { items: buzzword_topOne.values })
	# send_event('SixtoTen',{ items: buzzword_counts.values})
end


