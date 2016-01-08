require('sinatra')
require('sinatra/reloader')
require('firebase')
require('open-uri')
require('json')
require('pp')
require('date')
require('rufus-scheduler')
require('rspec')
require('nokogiri')

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
 				player[0] = (uid[1].values)[0]
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
	i = 0
	fakeArray = getSortedUsers()
	while i < fakeArray.length - 5 ;

 		buzzword_counts[fakeArray[i]] = { label: fakeArray[i][0], value: fakeArray[i][1] }
  		# puts buzzword_counts[Top5Players[i]].values
 		i += 1
	end
	send_event('OnetoFive', { items: buzzword_counts.values })
	# send_event('SixtoTen',{ items: buzzword_counts.values})
end


