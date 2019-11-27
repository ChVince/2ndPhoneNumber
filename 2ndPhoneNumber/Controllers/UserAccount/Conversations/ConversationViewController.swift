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
    var textMessageLabel = UILabel()

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
        textMessageLabel.textAlignment = .center
        textMessageLabel.font = .systemFont(ofSize: 16)

        dateLabel.textColor = .white
        dateLabel.textAlignment = .right
        dateLabel.font = .systemFont(ofSize: 12)

        contentView.addSubview(textMessageLabel)
        contentView.addSubview(dateLabel)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            textMessageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textMessageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
        ])

        NSLayoutConstraint.activate([
            attachmentsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            attachmentsView.topAnchor.constraint(equalTo: textMessageLabel.bottomAnchor, constant: 10),
            textMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
        ])

        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
        ])

    }

    func setupCellData() {
        textMessageLabel.text = message.message
        dateLabel.text = "4:20"//message.date
    }
}

class ConversationViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var accountViewModel: AccountViewModel!

    override func loadView() {
        super.loadView()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MessageCell.self))

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MessageCell.self), for: indexPath)

        return cell
    }
}
