# Social-Go

Social Go is a crowd sourced Pokemon radar and anonymous chat app for the iOS. It is built using Swift 2.2 and uses [Firebase](https://firebase.google.com/), [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) and [Google Maps](https://developers.google.com/maps/documentation/ios-sdk/).  

![Anonymous chat with every player wihtin a 5 mile radius](https://s3-us-west-2.amazonaws.com/reza-light/gif3.gif "Anonymous Chat")
![Live update of the map](https://s3-us-west-2.amazonaws.com/reza-light/gif4.gif "Live Update")
![Select Pokemon to broadcast its location](https://s3-us-west-2.amazonaws.com/reza-light/poke6.gif "Broadcast Pokemon Locationt")
## Installation
1. run `git clone https://github.com/kingreza/Social-Go.git`
2. run `Pod install`
3. Open `Pokemon.xcworkspace`
4. Sign up for [Firebase](https://firebase.google.com/)
5. Download `GoogleService-Info.plist` from your app's project setting and import it into your project
6. Click on Database on Firebase's console and import PokeJson.json
7. Build and run the project

## Usage
Social Go is minimal in features and the code should be rather easy to follow. Users select Pokemons they have spotted in the wild from a table. Their location and the Pokemon they have selected are sent to your Firebase database. All other users within about a 5 miles radius can see it appear live. 

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Credits
[Reza Shirazian](http://www.reza.codes) **[@KingReza](http://www.twitter.com/kingreza)**

