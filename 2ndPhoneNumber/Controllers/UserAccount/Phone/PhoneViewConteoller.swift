//
//  PhoneConteoller.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 06.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class KeyCellView: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    let digitsLabel = UILabel()
    let lettersLabel = UILabel()

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkBlue : .darkBlueWithOpacity
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkBlueWithOpacity

        digitsLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 24) : .systemFont(ofSize: 30)
        digitsLabel.textColor = .black
        digitsLabel.textAlignment = .center

        lettersLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 8) : .systemFont(ofSize: 13)
        lettersLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [digitsLabel, lettersLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = self.frame.width / 2
    }
}

class CallIconCell: UICollectionViewCell {
    let imageView  = UIImageView(image: UIImage(named: "call"))

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

class BackspaceCell: UICollectionViewCell {
    let imageView = UIImageView(image: UIImage(named: "erase"))

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

class DialedNumbersHeader: UICollectionReusableView {
    let numbersLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        numbersLabel.textAlignment = .center
        numbersLabel.adjustsFontSizeToFitWidth = true
        numbersLabel.font = .systemFont(ofSize: 40)
        numbersLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(numbersLabel)

        NSLayoutConstraint.activate([
            numbersLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            numbersLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            numbersLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            numbersLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhoneViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    fileprivate let cellId = "cellId"
    fileprivate let cellCallId = "cellCallId"
    fileprivate let backspaceCellId = "backspaceCellId"
    fileprivate let headerId = "headerId"
    private var inputString = ""

    let number = [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"
    ]

    let lettering = [
        "", "A B C", "D E F", "G H I", "J K L", "M N O", "P Q R S", "T U V", "W X Y Z", "", "+", ""
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(KeyCellView.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CallIconCell.self, forCellWithReuseIdentifier: cellCallId)
        collectionView.register(BackspaceCell.self, forCellWithReuseIdentifier: backspaceCellId)
        collectionView.register(DialedNumbersHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }



    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    //MARK: number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        }
        return number.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {

            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCallId, for: indexPath) as! CallIconCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: backspaceCellId, for: indexPath) as! BackspaceCell
                return cell
            }
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! KeyCellView
        cell.digitsLabel.text = number[indexPath.item]
        cell.lettersLabel.text = lettering[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! DialedNumbersHeader
        header.numbersLabel.text = inputString
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return .zero
        }
        let height = view.frame.height * 0.15
        return .init(width: view.frame.width, height: height)
    }

    //MARK: return size for 'Page' section
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let leftRightPadding = view.frame.width * 0.13
        let interSpacing = view.frame.width * 0.1


        let cellWidth = (view.frame.width - 2 * leftRightPadding - 2 * interSpacing) / 3
        return .init(width: cellWidth, height: cellWidth)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            if indexPath.section == 1  {
                inputString = String(inputString.dropLast())
            }
        } else {
            inputString += number[indexPath.item]
        }

        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if section == 1 {
            let leftRightPadding = view.frame.width * 0.13
            let interSpacing = view.frame.width * 0.1


            let cellWidth = (view.frame.width - 2 * leftRightPadding - 2 * interSpacing) / 3

            let leftPadding = view.frame.width / 2 - cellWidth / 2
            return .init(top: 0, left: leftPadding, bottom: 0, right: leftRightPadding)
        }

        let leftRightPadding = view.frame.width * 0.15
        //let interSpacing = view.frame.width * 0.1

        return .init(top: 16, left: leftRightPadding, bottom: 16, right: leftRightPadding)
    }
}
