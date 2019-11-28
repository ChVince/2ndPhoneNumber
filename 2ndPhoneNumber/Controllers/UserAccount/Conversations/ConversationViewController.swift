//
//  ConversationViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 27.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

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
        textMessageLabel.textColor = .white

        textMessageLabel.backgroundColor = .clear
        textMessageLabel.textAlignment = .left
        textMessageLabel.font = .systemFont(ofSize: 16)

        dateLabel.textColor = .white
        dateLabel.textAlignment = .right
        dateLabel.font = .systemFont(ofSize: 12)

        textMessageLabel.text = "Sample!!!!!"

        contentView.addSubview(textMessageLabel)
        //contentView.addSubview(dateLabel)
        //contentView.addSubview(attachmentsView)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            textMessageLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
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

        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
        ])
         */

    }

    func setupCellData() {
        if message.author == .USER {
            contentView.backgroundColor = .lightBlue
        }

        if message.author == .COLLOCUTOR {
            contentView.backgroundColor = .darkBlue
        }

        textMessageLabel.text = message.message
        dateLabel.text = "4:20"//message.date
    }
}

class ConversationViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var conversationViewModel: ConversationViewModel!

    override func loadView() {
        super.loadView()
        self.collectionView.backgroundColor = .gray
        self.collectionView!.register(MessageCell.self, forCellWithReuseIdentifier: String(describing: MessageCell.self))

        /*if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
 */
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversationViewModel.getMessageList().count
    }

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MessageCell.self), for: indexPath) as! MessageCell
        cell.message = conversationViewModel.getMessageList()[indexPath.item]

        return cell
    }
}
