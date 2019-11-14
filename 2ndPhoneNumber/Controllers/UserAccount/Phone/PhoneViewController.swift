//
//  PhoneConteoller.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 06.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

struct UIDimension {
    var width: CGFloat
    var height: CGFloat
}

class KeyCellView: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    let digitsLabel: UILabel = {
        let _digitsLabel = UILabel()
        _digitsLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 24) : .systemFont(ofSize: 28)
        _digitsLabel.textColor = .black
        _digitsLabel.textAlignment = .center
        return _digitsLabel
    }()

    let lettersLabel: UILabel = {
        let _lettersLabel = UILabel()
        _lettersLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 8) : .systemFont(ofSize: 10)
        _lettersLabel.textAlignment = .center

        return _lettersLabel
    }()

    let labelContainer: UIStackView = {
        let _labelContainer = UIStackView()
        _labelContainer.translatesAutoresizingMaskIntoConstraints = false
        _labelContainer.axis = .vertical
        return _labelContainer
    }()

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkBlue : .darkBlueWithOpacity
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkBlueWithOpacity

        labelContainer.addArrangedSubview(digitsLabel)
        labelContainer.addArrangedSubview(lettersLabel)

        contentView.addSubview(labelContainer)
        NSLayoutConstraint.activate([
            labelContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = self.frame.width / 2
    }

    func setCellLabels(digitsLabel: String, lettersLabel: String) {
        self.digitsLabel.text = digitsLabel
        self.lettersLabel.text = lettersLabel
    }
}

class PhoneCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let _imageView = UIImageView(image: UIImage(named: "call"))
        _imageView.contentMode = .scaleAspectFit
        _imageView.translatesAutoresizingMaskIntoConstraints = false

        return  _imageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkBlue
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

class BackspaceCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let _imageView = UIImageView(image: UIImage(named: "erase"))
        _imageView.contentMode = .scaleAspectFit
        _imageView.translatesAutoresizingMaskIntoConstraints = false

        return _imageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

class PhoneViewHeader: UICollectionReusableView {
    let inputLabel: UILabel = {
        let _inputLabel = UILabel()
        _inputLabel.textAlignment = .center
        _inputLabel.adjustsFontSizeToFitWidth = true
        _inputLabel.font = .systemFont(ofSize: 40)
        _inputLabel.translatesAutoresizingMaskIntoConstraints = false

        return _inputLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(inputLabel)
        NSLayoutConstraint.activate([
            inputLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            inputLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 16),
            inputLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            inputLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setInputValue(inputValue: String) {
        inputLabel.text = inputValue
    }
}

class PhoneViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    private let phoneCellId = "phoneCellId"
    private let backspaceCellId = "backspaceCellId"
    private let headerId = "headerId"
    private var inputValue = ""

    let FIRST_SECTION_KEYS_COUNT = 9
    let SECOND_SECTION_KEYS_COUNT = 2

    var accountViewModel: AccountViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(KeyCellView.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PhoneCell.self, forCellWithReuseIdentifier: phoneCellId)
        collectionView.register(BackspaceCell.self, forCellWithReuseIdentifier: backspaceCellId)
        collectionView.register(PhoneViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
}


extension PhoneViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    //MARK: number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? FIRST_SECTION_KEYS_COUNT : SECOND_SECTION_KEYS_COUNT
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let phoneDigits = accountViewModel.getPhoneDigits()
            let phoneLetters = accountViewModel.getPhoneLetters()

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! KeyCellView
            cell.setCellLabels(digitsLabel: phoneDigits[indexPath.item], lettersLabel: phoneLetters[indexPath.item])
            return cell
        }

        if indexPath.section == 1 && indexPath.item == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: phoneCellId, for: indexPath) as! PhoneCell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: backspaceCellId, for: indexPath) as! BackspaceCell
        }
    }

    //MARK: return header view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! PhoneViewHeader
        header.setInputValue(inputValue: inputValue)
        return header
    }

    //MARK: return size of section header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? .init(
            width: view.frame.width,
            height: view.frame.height * 0.15
        ) : .zero
    }

    //MARK: return size for item
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let cellSize = self.getCellSize()
        return .init(width: cellSize.width, height: cellSize.height)
    }

    //MARK: On item select
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.item == 0 {
            accountViewModel.callByNumber(number: inputValue)
            return
        }

        if indexPath.section == 0 {
            let phoneDigits = accountViewModel.getPhoneDigits()
            inputValue += phoneDigits[indexPath.item]
        } else {
            inputValue = String(inputValue.dropLast())
        }

        collectionView.reloadData()
    }

    //MARK: Min Space between sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightPadding = view.frame.width * 0.15

        if section == 1 {
            let cellSize = self.getCellSize()
            let leftPadding = view.frame.width / 2 - cellSize.width / 2
            return .init(top: 0, left: leftPadding, bottom: 0, right: leftRightPadding)
        }

        return .init(top: 32, left: leftRightPadding, bottom: 16, right: leftRightPadding)
    }


    func getCellSize() -> UIDimension {
        let leftRightPadding = view.frame.width * 0.1
        let interSpacing = view.frame.width * 0.1
        let itemWidth = (view.frame.width - 2 * leftRightPadding - 2 * interSpacing) / 3

        return UIDimension(width: itemWidth, height: itemWidth)
    }
}
