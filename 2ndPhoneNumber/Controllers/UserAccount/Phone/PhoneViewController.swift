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

class KeyCellView: UICollectionViewCell {
    var digitsLabel = UILabel()
    var lettersLabel = UILabel()

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkBlue : .darkBlueWithOpacity
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkBlueWithOpacity

        setupDigitsLabel()
        setupLettersLabel()

        setupLabelContainer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupDigitsLabel() {
        digitsLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 24) : .systemFont(ofSize: 28)
        digitsLabel.textColor = .black
        digitsLabel.textAlignment = .center
    }

    func setupLettersLabel() {
        lettersLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 8) : .systemFont(ofSize: 10)
        lettersLabel.textAlignment = .center
    }

    func setupLabelContainer() {
        let labelContainer = UIStackView()
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        labelContainer.axis = .vertical

        labelContainer.addArrangedSubview(digitsLabel)
        labelContainer.addArrangedSubview(lettersLabel)

        contentView.addSubview(labelContainer)

        NSLayoutConstraint.activate([
            labelContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }

    func setDigitsLabel(digitsLabel: String) {
        self.digitsLabel.text = digitsLabel
    }

    func setLettersLabel(lettersLabel: String) {
        self.lettersLabel.text = lettersLabel
    }
}

class PhoneCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkBlue

        setupImageView()
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    func setupImageView() {
        let imageView = UIImageView(image: UIImage(named: "phoneCall"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        imageView.alignXYCenter()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }
}

class BackspaceCell: UICollectionViewCell {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupImageView()
    }

    func setupImageView() {
        let imageView = UIImageView(image: UIImage(named: "erase"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        imageView.alignXYCenter()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }
}

class PhoneViewHeader: UICollectionReusableView {
    @UsesAutoLayout
    var inputLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInputLabel()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupInputLabel() {
        inputLabel.textAlignment = .center
        inputLabel.adjustsFontSizeToFitWidth = true
        inputLabel.font = .systemFont(ofSize: 40)

        addSubview(inputLabel)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            inputLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            inputLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 16),
            inputLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            inputLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
    }

    func setInputValue(inputValue: String) {
        inputLabel.text = inputValue
    }
}

class PhoneViewController: AccountDropdownNavigationController {
    var phoneViewModel: PhoneViewModel!

    private var inputValue = ""// account view model

    let FIRST_SECTION_KEYS_COUNT = 9
    let SECOND_SECTION_KEYS_COUNT = 2

    @UsesAutoLayout
    var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0) ,collectionViewLayout: UICollectionViewFlowLayout())

    override func loadView() {
        super.loadView()
        collectionView.backgroundColor = .white
        collectionView.register(KeyCellView.self, forCellWithReuseIdentifier: String(describing: KeyCellView.self))
        collectionView.register(PhoneCell.self, forCellWithReuseIdentifier: String(describing: PhoneCell.self))
        collectionView.register(BackspaceCell.self, forCellWithReuseIdentifier: String(describing: BackspaceCell.self))
        collectionView.register(PhoneViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PhoneViewHeader.self))

        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension PhoneViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    //MARK: number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? FIRST_SECTION_KEYS_COUNT : SECOND_SECTION_KEYS_COUNT
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let phoneDigits = phoneViewModel.getPhoneDigits()
            let phoneLetters = phoneViewModel.getPhoneLetters()

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: KeyCellView.self), for: indexPath) as! KeyCellView

            cell.setLettersLabel(lettersLabel: phoneLetters[indexPath.item])
            cell.setDigitsLabel(digitsLabel: phoneDigits[indexPath.item])

            return cell
        }

        if indexPath.section == 1 && indexPath.item == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhoneCell.self), for: indexPath) as! PhoneCell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BackspaceCell.self), for: indexPath) as! BackspaceCell
        }
    }

    //MARK: return header view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PhoneViewHeader.self), for: indexPath) as! PhoneViewHeader
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.item == 0 {
            phoneViewModel.callByNumber(number: inputValue)
            return
        }

        if indexPath.section == 0 {
            let phoneDigits = phoneViewModel.getPhoneDigits()
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
