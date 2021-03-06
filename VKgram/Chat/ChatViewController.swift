//
//  ChatViewController.swift
//  VKgram
//
//  Created by Andrey on 09/11/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
//import FirebaseFirestore

class ChatViewController: MessagesViewController {
    
    let mockMessage1 = MMessage(user: MUser(username: "Alex", email: "alex@gmail.com", avatarStringURL: "https://lh3.googleusercontent.com/i1ntSY7ACWnaxtdxI0KO9vHh0UNtXRin1YNnSVCpfmE5JH9752u4tFLyd-gWM9Hi-zyASAW8lYXnNvLfT7LHJUVJOgjAqbA74b0-m-UU8XdZSiFnTnYRADTmRVyXOiprgp0TsiGv=w2400", description: "SomeDescription", sex: "Male", id: "someTestID123"), content: "Hallo? how are you?")
    
    let mockMessage2 = MMessage(user: MUser(username: "Slava", email: "slava@gmail.com", avatarStringURL: "https://lh3.googleusercontent.com/i1ntSY7ACWnaxtdxI0KO9vHh0UNtXRin1YNnSVCpfmE5JH9752u4tFLyd-gWM9Hi-zyASAW8lYXnNvLfT7LHJUVJOgjAqbA74b0-m-UU8XdZSiFnTnYRADTmRVyXOiprgp0TsiGv=w2400", description: "SomeDescription", sex: "Male", id: "someTestID124"), content: "I'm good and you?")
    
    let mockMessage3 = MMessage(user: MUser(username: "Alex", email: "alex@gmail.com", avatarStringURL: "https://lh3.googleusercontent.com/i1ntSY7ACWnaxtdxI0KO9vHh0UNtXRin1YNnSVCpfmE5JH9752u4tFLyd-gWM9Hi-zyASAW8lYXnNvLfT7LHJUVJOgjAqbA74b0-m-UU8XdZSiFnTnYRADTmRVyXOiprgp0TsiGv=w2400", description: "SomeDescription", sex: "Male", id: "someTestID123"), content: "I'm so fine!")
    
//    private var messageListener: ListenerRegistration?
    
    lazy private var messages: [MMessage] = [mockMessage1, mockMessage2, mockMessage3]
    
    private let user: MUser
    private let chat: MChat
    
    init(user: MUser, chat: MChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        
        title = chat.friendUsername
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        messageListener?.remove()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageInputBar()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        messagesCollectionView.backgroundColor = .magenta
//        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
//        messageListener = ListenerService.shared.messagesObserve(chat: chat, completion: { (result) in
//            switch result {
//
//            case .success(let message):
//                self.insertNewMessage(message: message)
//            case .failure(let error):
//                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
//            }
//        })
    }
    
    private func insertNewMessage(message: MMessage) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
}

// MARK: - ConfigureMessageInputBar
extension ChatViewController {
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .cyan
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        
        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
    }
    
    func configureSendButton() {
        messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
//        messageInputBar.sendButton.applyGradients(cornerRadius: 10)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: user.id, displayName: user.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.item % 4 == 0 {
            return NSAttributedString(
            string: MessageKitDateFormatter.shared.string(from: message.sentDate),
            attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        } else {
            return nil
        }
    }
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (indexPath.item) % 4 == 0 {
            return 30
        } else {
            return 0
        }
    }
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
}

// MARK: - MessageInputBarDelegate
//extension ChatViewController: MessageInputBarDelegate {
//    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        let message = MMessage(user: user, content: text)
//        FirestoreService.shared.sendMessage(chat: chat, message: message) { (result) in
//            switch result {
//            case .success:
//                self.messagesCollectionView.scrollToBottom()
//            case .failure(let error):
//                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
//            }
//        }
//        inputBar.inputTextView.text = ""
//    }
//}


extension UIScrollView {
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForBottom: CGFloat {
      let scrollViewHeight = bounds.height
      let scrollContentSizeHeight = contentSize.height
      let bottomInset = contentInset.bottom
      let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
      return scrollViewBottomOffset
    }
}

