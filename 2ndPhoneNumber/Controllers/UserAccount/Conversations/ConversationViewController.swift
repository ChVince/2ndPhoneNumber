//
//  ConversationViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 27.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

protocol ConversationLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, _ conversationLayout: ConversationLayout, sizeForMessageAtIndexPath indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, _ conversationLayout: ConversationLayout, _ estimatedSize: CGSize, xOffsetForMessageAtIndexPath indexPath: IndexPath) -> CGFloat

    func getMessageOffset(_ collectionView: UICollectionView, currentMessageIndexPath: IndexPath, nextMessageIndexPath: IndexPath) -> CGFloat
}

class ConversationLayout: UICollectionViewLayout {
    weak var delegate: ConversationLayoutDelegate?

    let messageHeightInsetPadding: CGFloat = 10
    let messageWidthInsetPadding: CGFloat = 20

    private let defaultMessagePadding: CGFloat = 15

    private var contentBounds = CGRect.zero
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }

        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)

        createAttributes()
    }

    func createAttributes() {
        guard cachedAttributes.isEmpty,
            let collectionView = collectionView else {
            return
        }

        var yOffset: CGFloat = defaultMessagePadding

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let messageSize = delegate?.collectionView(collectionView, self, sizeForMessageAtIndexPath: indexPath) ?? .zero
            let xOffset = delegate?.collectionView(collectionView, self, messageSize, xOffsetForMessageAtIndexPath: indexPath) ?? .zero

            let messageOffset: CGFloat

            if item + 1 < collectionView.numberOfItems(inSection: 0) {
                let nextIndexPath = IndexPath(item: item + 1, section: 0)
                messageOffset = delegate?.getMessageOffset(collectionView, currentMessageIndexPath: indexPath, nextMessageIndexPath: nextIndexPath) ?? defaultMessagePadding
            } else {
                messageOffset = defaultMessagePadding
            }

            let height = messageHeightInsetPadding * 2 + messageSize.height
            let width = messageSize.width

            let frame = CGRect(x: xOffset,
                               y: yOffset,
                               width: width,
                               height: height)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cachedAttributes.append(attributes)

            yOffset = yOffset + height + messageOffset
        }
    }

    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }

        return !newBounds.size.equalTo(collectionView.bounds.size)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter { (attributes: UICollectionViewLayoutAttributes) -> Bool in
            return rect.intersects(attributes.frame)
        }
    }

}

class MessageCell: UICollectionViewCell {
    var message: Message! {
        didSet {
            setupCellData()
        }
    }

    @UsesAutoLayout
    var dateLabel = UILabel()

    @UsesAutoLayout
    var textMessageLabel = UITextView()

    @UsesAutoLayout
    var attachmentsView = UIStackView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame);

        setupSubviews()
        setupLayout()
    }

    func setupSubviews() {

        contentView.layer.cornerRadius = 8.0
        contentView.clipsToBounds = true

        textMessageLabel.textColor = .white

        textMessageLabel.backgroundColor = .clear
        textMessageLabel.textAlignment = .left
        textMessageLabel.font = .systemFont(ofSize: 16)
        textMessageLabel.isEditable = false

        dateLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        dateLabel.textAlignment = .right
        dateLabel.font = .systemFont(ofSize: 12)

        contentView.addSubview(textMessageLabel)
        contentView.addSubview(dateLabel)
        //contentView.addSubview(attachmentsView)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            textMessageLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textMessageLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            textMessageLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])

        /*
        NSLayoutConstraint.activate([
            //attachmentsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            attachmentsView.topAnchor.constraint(equalTo: textMessageLabel.bottomAnchor, constant: 10),
            attachmentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            attachmentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
        ])
         */

        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    func setupCellData() {
        if message.author == .USER {
            contentView.backgroundColor = .lightBlue
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }

        if message.author == .COLLOCUTOR {
            contentView.backgroundColor = .darkBlue
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }

        textMessageLabel.text = message.message
        dateLabel.text = "4:20"//message.date
    }
}

class ConversationHeader: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ConversationFooter: UICollectionReusableView {

    var delegate: ConversationViewController!

    var conversationFooterStackView = UIStackView()

    var attachmentsButton = UIButton(type: .system)
    var messageField = UITextField()
    var sendMessageButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .red

        setupSubviews()
        setupLayout()
        setupHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        addSubview(conversationFooterStackView)

        conversationFooterStackView.addArrangedSubview(attachmentsButton)
        conversationFooterStackView.addArrangedSubview(messageField)

        messageField.addSubview(sendMessageButton)

        conversationFooterStackView.spacing = 20

        attachmentsButton.setImage(UIImage(systemName: "camera"), for: .normal)
        sendMessageButton.setImage(UIImage(named: "send"), for: .normal)

        messageField.placeholder = NSLocalizedString("label.conversation.message.placeholder", comment: "")
    }

    func setupLayout() {

    }

    func setupHandlers() {
        sendMessageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        messageField.addTarget(self, action: #selector(setMessageText), for: .editingChanged)
    }

    @objc func setMessageText() {
        delegate.setMessageText(text: messageField.text ?? "")
    }

    @objc func addAttachment() {
        delegate.addAttachment()
    }

    @objc func sendMessage() {
        delegate.sendMessage()
    }
}

class ConversationViewController: UIViewController {
    var conversationViewModel: ConversationViewModel!

    var collectionView: UICollectionView!

    override func loadView() {
        super.loadView()

        setupSubviews()
    }
    
    func setupSubviews() {
        let conversationLayout = ConversationLayout()
        conversationLayout.delegate = self

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: conversationLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: String(describing: MessageCell.self))

        /*
        collectionView.register(ConversationHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: ConversationHeader.self))

        collectionView.register(ConversationFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: ConversationFooter.self))
         */

        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
    }

    func addAttachment() {

    }

    func setMessageText(text: String) {
        conversationViewModel.setMessageText(text: text)
    }

    func sendMessage() {
        conversationViewModel.sendMessage{ [weak self] in

        }
    }
}

extension ConversationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversationViewModel.getMessageList().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MessageCell.self), for: indexPath) as! MessageCell
        cell.message = conversationViewModel.getMessageList()[indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: ConversationHeader.self), for: indexPath) as! ConversationHeader
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: ConversationFooter.self), for: indexPath) as! ConversationFooter
        }
    }
}

extension ConversationViewController: ConversationLayoutDelegate {
    func getMessageOffset(_ collectionView: UICollectionView, currentMessageIndexPath: IndexPath, nextMessageIndexPath: IndexPath) -> CGFloat {
        let sameAuthorMessagePadding: CGFloat = 15
        let nextAuthorMessagePadding: CGFloat = 30

        let conversation: Conversation = conversationViewModel.conversation
        guard let messageList = conversation.messageList else {
            return .zero
        }

        let currentMessage: Message = messageList[currentMessageIndexPath.item]
        let nextMessage: Message = messageList[nextMessageIndexPath.item]

        if currentMessage.author != nextMessage.author {
            return nextAuthorMessagePadding
        }

        return sameAuthorMessagePadding
    }

    func collectionView(_ collectionView: UICollectionView, _ conversationLayout: ConversationLayout, sizeForMessageAtIndexPath indexPath: IndexPath) -> CGSize {
        let conversation: Conversation = conversationViewModel.conversation
        guard let messageList = conversation.messageList else {
            return .zero
        }

        let message: Message = messageList[indexPath.item]
        let maxWidth = view.bounds.size.width * 0.7
        let minWidth = view.bounds.size.width * 0.1
        let dateFieldHeight: CGFloat = 20

        let messageAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        var attributedMessage = NSAttributedString(string: message.message, attributes: messageAttributes)

        let estimatedBounds = attributedMessage.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),  options: [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics], context: nil)

        let height = estimatedBounds.height + dateFieldHeight

        let estimatedWidth = estimatedBounds.width + conversationLayout.messageWidthInsetPadding * 2
        let width = max(estimatedWidth, minWidth)

        return CGSize(
            width: width,
            height: height
        )
    }

    func collectionView(_ collectionView: UICollectionView, _ conversationLayout: ConversationLayout, _ estimatedSize: CGSize,  xOffsetForMessageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let conversation: Conversation = conversationViewModel.conversation
        let offsetPadding: CGFloat = 15
        var offset = offsetPadding

        guard let messageList = conversation.messageList else {
            return offset
        }

        let message: Message = messageList[indexPath.item]

        if message.author == .USER {
            offset = view.bounds.size.width - estimatedSize.width - offsetPadding
        }

        if message.author == .COLLOCUTOR {
            offset = offsetPadding
        }

        return offset
    }
}
