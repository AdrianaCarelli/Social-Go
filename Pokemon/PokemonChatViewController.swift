//
//  PokemonChatViewController.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-19.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//


import Firebase
import JSQMessagesViewController
import CoreLocation

class PokemonChatViewController: JSQMessagesViewController {
  // MARK: Properties
  var rootRef: FIRDatabaseReference! = nil
  var messageRef: FIRDatabaseReference! = nil
  var messages = [JSQMessage]()
  var currentLat: Int?
  var currentLong: Int?
  var userColors = [String:UIColor]()


  var usersTypingQuery: FIRDatabaseQuery!
  private var localTyping = false

  var outgoingBubbleImageView: JSQMessagesBubbleImage!
  var incomingBubbleImageView: JSQMessagesBubbleImage!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.senderDisplayName = "A Pokemon Master"
    self.senderId = UserManager.instance.user!.uid
    self.rootRef = FIRDatabase.database().reference()
    setupBubbles()
    messageRef = rootRef.child("messages")

    // No avatars
    collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero

  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    observeMessages()

  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    print("pop")
  }
  override func willMoveToParentViewController(parent: UIViewController?) {
    if parent == nil {
      LocationManager.instance.removeLastListener()
      rootRef.removeAllObservers()
      let storybboard = UIStoryboard(name: "Main", bundle: nil)
      let viewController = storybboard.instantiateViewControllerWithIdentifier("HomeView")
      self.presentViewController(viewController, animated: true, completion: nil)
      return
    }
  }

  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
  }

  override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    return messages[indexPath.item]
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }

  override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = messages[indexPath.item] // 1
    if message.senderId == senderId { // 2
      return outgoingBubbleImageView
    } else { // 3
      return incomingBubbleImageView
    }
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell

    let message = messages[indexPath.item]

    if message.senderId == senderId { // 1
      cell.textView!.textColor = UIColor.whiteColor() // 2
    } else {
      if let color = self.userColors[message.senderId] {
        cell.textView!.backgroundColor = color // 3
      } else {
        self.userColors[message.senderId] = self.getRandomColor()
        cell.textView!.backgroundColor = self.userColors[message.senderId]
      }
    }

    return cell
  }

  override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }

  func getRandomColor() -> UIColor {

    let randomRed: CGFloat = CGFloat(drand48())

    let randomGreen: CGFloat = CGFloat(drand48())

    let randomBlue: CGFloat = CGFloat(drand48())

    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)

  }

  private func observeMessages() {
    LocationManager.instance.subscribeToUserLocation() { (location) in
      let lat = ComsManager.instance.longLatToInteger(location.coordinate.latitude)
      let long = ComsManager.instance.longLatToInteger(location.coordinate.longitude)
      if self.currentLong == nil && self.currentLat == nil {
        self.currentLat = lat
        self.currentLong = long
        let messagesQuery = self.messageRef.child("latitude").child("\(lat)").child("longitude").child("\(long)").queryLimitedToLast(25)
//        messagesQuery.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot!) in
//          // 3
//          if let snapshotDics = snapshot.value as? [String: AnyObject] {
//          for (_, snapshotDic) in snapshotDics {
//            let id = snapshotDic["senderId"] as! String
//            let text = snapshotDic["text"] as! String
//            // 4
//            self.addMessage(id, text: text)
//            // 5
//            self.finishReceivingMessage()
//            }
//          }
//        }
        
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot!) in
          // 3
          let snapshotDic = snapshot.value! as! [String: AnyObject]
          let id = snapshotDic["senderId"] as! String
          let text = snapshotDic["text"] as! String
          // 4
          self.addMessage(id, text: text)
          // 5
          self.finishReceivingMessage()
        }

      } else if self.currentLong! != long || self.currentLat! != lat {
        self.currentLat = lat
        self.currentLong = long
        let messagesQuery = self.messageRef.child("latitude").child("\(lat)").child("longitude").child("\(long)").queryLimitedToLast(25)
        // 2
        self.rootRef.removeAllObservers()
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot!) in
          // 3
          let snapshotDic = snapshot.value! as! [String: AnyObject]
          let id = snapshotDic["senderId"] as! String
          let text = snapshotDic["text"] as! String
          // 4
          self.addMessage(id, text: text)
          // 5
          self.finishReceivingMessage()
        }
      }
    }
  }

  func addMessage(id: String, text: String) {
    let message = JSQMessage(senderId: id, displayName: "You", text: text)
    messages.append(message)
  }

  override func textViewDidChange(textView: UITextView) {
    super.textViewDidChange(textView)
    // If the text is not empty, the user is typing

  }

  override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {

    LocationManager.instance.getUserLocation { (location) in
      let lat = ComsManager.instance.longLatToInteger(location.coordinate.latitude)
      let long = ComsManager.instance.longLatToInteger(location.coordinate.longitude)
      let messagesQuery = self.messageRef.child("latitude").child("\(lat)").child("longitude").child("\(long)")
      let itemRef = messagesQuery.childByAutoId()
      let messageItem = [ // 2
        "text": text,
        "senderId": senderId,
        "latitude": location.coordinate.latitude,
        "longitude": location.coordinate.longitude
      ]
      // 2
      itemRef.setValue(messageItem) // 3
      JSQSystemSoundPlayer.jsq_playMessageSentSound()
      self.finishSendingMessage()
    }

  }

  private func setupBubbles() {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    outgoingBubbleImageView = bubbleImageFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    incomingBubbleImageView = bubbleImageFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
  }
}
