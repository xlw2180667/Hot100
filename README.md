# Hot 100 
###### Stay tuned for you

##Description
Hot 100 is an iOS app showing top 100 popluar song from Billboard. You could scroll to browse the list or search for it. Moreover, feel free to tap in each song to see more details and listen its sample audio from iTunes(totally legal^^).

##Feature
###Search
Users can search the song in the search bar. The tableview shows the search result real-time.
###Song sample
Users can listen the preview version song by clicking the Play button. If they like the song, click the Buy button, easy to jump to iTunes to buy or download it.
###Other
I used two libraries, sqlite3 and AVFoundation. Sqlite3 helps me use sqlite database to store my song data. AVAudioPlayer in AVFoundation helps me achieve the song play feature. 

##UI/UX
###Hidden search bar
The search bar is located at the top of the song list view, but it is hidden when the app is initialized. I did it for two UX reasons:
1. As a searching action occurs less frequently than a browsing action, it should give more space for the song list.
2. Usually a searching action comes with strong incentives, 'drag down to reveal the bar' is an acceptable action for users.
###Smooth navigation
An extra thread is used for fetching the song data so that the main thread for UI will not be intrrupted.
###Better looking
The background of each song's description is an blur image of the single.
