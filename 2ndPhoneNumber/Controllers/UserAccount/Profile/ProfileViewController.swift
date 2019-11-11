//
//  ProfileViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 06.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit
import WebKit
import FlagKit

private struct MenuItemDescription {
    var imageName: String
    var menuLabel: String
}

class ProfileViewController: UIViewController, WKUIDelegate {
    let accountViewModel: AccountViewModel = AccountViewModel()

    private let menuDescriptionList = [
        MenuItemDescription(imageName: "privacy", menuLabel: NSLocalizedString("label.profile.privacy", comment: "")),
        MenuItemDescription(imageName: "terms", menuLabel: NSLocalizedString("label.profile.terms.of.use", comment: "")),
        MenuItemDescription(imageName: "support", menuLabel: NSLocalizedString("label.profile.support", comment: "")),
        MenuItemDescription(imageName: "share", menuLabel: NSLocalizedString("label.profile.share", comment: ""))
    ]

    let numberListView: UIStackView = {
        let _numberListView = UIStackView()
        _numberListView.axis = .vertical
        _numberListView.translatesAutoresizingMaskIntoConstraints = false
        _numberListView.spacing = 0
        _numberListView.alignment = .center

        return _numberListView
    }()

    let topBallanceButton: UIView = {
        let _topBalanceButtonContainer = UIView()
        _topBalanceButtonContainer.backgroundColor = .white
        _topBalanceButtonContainer.translatesAutoresizingMaskIntoConstraints = false

        var _button = UIButton(type: .system)
        _button.setTitle(NSLocalizedString("label.profile.balance", comment: "").uppercased(), for: .normal)
        _button.titleLabel!.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 12, weight:.medium) : UIFont.systemFont(ofSize: 14, weight:.medium)
        _button.translatesAutoresizingMaskIntoConstraints = false
        _button.backgroundColor = UIColor.darkBlue
        _button.setTitleColor(UIColor.white, for: .normal)
        _button.layer.cornerRadius = 15

        _topBalanceButtonContainer.addSubview(_button)

        NSLayoutConstraint.activate([
            _button.topAnchor.constraint(equalTo: _topBalanceButtonContainer.topAnchor, constant: 5),
            _button.centerXAnchor.constraint(equalTo: _topBalanceButtonContainer.centerXAnchor),
            _button.widthAnchor.constraint(equalToConstant: 200),
            _button.heightAnchor.constraint(equalToConstant: 30)
        ])

        return _topBalanceButtonContainer
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    let menuView: UIStackView = {
        let _menuView = UIStackView()
        _menuView.spacing = 1
        _menuView.axis = .vertical
        _menuView.alignment = .center
        _menuView.translatesAutoresizingMaskIntoConstraints = false
        return _menuView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGrayF2

        setupLayout()
    }

    func setupLayout() {
        setupContainerView()
        setupNumberListView()
        setupTopBalanceButton()
        setupMenuView()
    }

    func setupContainerView() {
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    func setupNumberListView() {
        let numberList = accountViewModel.getAccountNumbers()
        let numberListViewContainer = UIView()
        numberListViewContainer.addSubview(numberListView)
        numberListViewContainer.backgroundColor = .white
        numberListViewContainer.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(numberListViewContainer)


        numberList.forEach({ (number) in
            let numberView = self.createNumberView(accountNumber: number)
            numberListView.addArrangedSubview(numberView)

            let cellHeight: CGFloat = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 45 : 55
            NSLayoutConstraint.activate([
                numberView.heightAnchor.constraint(equalToConstant: cellHeight),
                numberView.widthAnchor.constraint(equalTo: numberListView.widthAnchor)
            ])
        })


        NSLayoutConstraint.activate([
            numberListView.topAnchor.constraint(equalTo: numberListViewContainer.topAnchor, constant: 25),
            numberListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            numberListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])

        NSLayoutConstraint.activate([
            numberListViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            numberListViewContainer.bottomAnchor.constraint(equalTo: numberListView.bottomAnchor),
            numberListViewContainer.widthAnchor.constraint(equalToConstant: view.frame.width),
        ])

    }

    func setupTopBalanceButton() {
        scrollView.addSubview(topBallanceButton)

        NSLayoutConstraint.activate([
            topBallanceButton.topAnchor.constraint(equalTo: numberListView.bottomAnchor),
            topBallanceButton.widthAnchor.constraint(equalToConstant: view.frame.width),
            topBallanceButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    func setupMenuView() {
        scrollView.addSubview(menuView)
        menuDescriptionList.forEach({ (menuItemDescription) in
            let menuItemView = self.createMenuItem(menuItemDescription: menuItemDescription)
            menuView.addArrangedSubview(menuItemView)

            NSLayoutConstraint.activate([
                menuItemView.heightAnchor.constraint(equalToConstant: 50),
                menuItemView.widthAnchor.constraint(equalTo: menuView.widthAnchor)
            ])
        })



        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: topBallanceButton.bottomAnchor, constant: 20),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            menuView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func createMenuItem(menuItemDescription: MenuItemDescription) -> UIView {
        let menuIconView = getMenuIconView(imageName: menuItemDescription.imageName)
        let menuLabelView = getMenuLabelView(menuLabelText: menuItemDescription.menuLabel)

        let menuItemView = UIStackView(arrangedSubviews: [menuIconView, menuLabelView])

        menuItemView.setCustomSpacing(25, after: menuIconView)
        menuItemView.axis = .horizontal
        menuItemView.distribution = .fill
        menuItemView.alignment = .center
        menuItemView.translatesAutoresizingMaskIntoConstraints = false
        menuItemView.isLayoutMarginsRelativeArrangement = true
        menuItemView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 25)

        let menuItemViewContainer = UIView()
        menuItemViewContainer.backgroundColor = .white
        menuItemViewContainer.addSubview(menuItemView)

        NSLayoutConstraint.activate([
            menuItemView.leadingAnchor.constraint(equalTo: menuItemViewContainer.leadingAnchor),
            menuItemView.trailingAnchor.constraint(equalTo: menuItemViewContainer.trailingAnchor),
            menuItemView.heightAnchor.constraint(equalTo: menuItemViewContainer.heightAnchor)
        ])

        return menuItemViewContainer
    }

    func getMenuIconView(imageName: String) -> UIView {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return imageView
    }

    func getMenuLabelView(menuLabelText: String) -> UIView {
        let menuLabel = UILabel()
        menuLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 12) : .systemFont(ofSize: 16)
        menuLabel.textColor = .black
        menuLabel.text = menuLabelText

        return menuLabel
    }

    func createNumberView(accountNumber: AccountNumber) -> UIView {
        let imageView = getFlagView(accountNumber: accountNumber)
        let numberLabelView = getNumberLabel(accountNumber: accountNumber)
        let numberTagView = getNumberTag(accountNumber: accountNumber)

        let secondLineNumberInfoView = getNumberInfoView(accountNumber: accountNumber)
        let firstLineNumberView = UIStackView(arrangedSubviews: [imageView, numberLabelView, numberTagView])

        firstLineNumberView.setCustomSpacing(8, after: imageView)
        firstLineNumberView.axis = .horizontal
        firstLineNumberView.distribution = .fill
        firstLineNumberView.translatesAutoresizingMaskIntoConstraints = false

        let numberView = UIStackView(arrangedSubviews: [firstLineNumberView, secondLineNumberInfoView])
        numberView.translatesAutoresizingMaskIntoConstraints = false
        numberView.axis = .vertical
        numberView.setCustomSpacing(2, after: firstLineNumberView)

        NSLayoutConstraint.activate([
            firstLineNumberView.leadingAnchor.constraint(equalTo: numberView.leadingAnchor),
            firstLineNumberView.trailingAnchor.constraint(equalTo: numberView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            secondLineNumberInfoView.leadingAnchor.constraint(equalTo: numberView.leadingAnchor),
            secondLineNumberInfoView.trailingAnchor.constraint(equalTo: numberView.trailingAnchor)
        ])

        let numberViewContainer = UIView()
        numberViewContainer.addSubview(numberView)

        NSLayoutConstraint.activate([
            numberView.leadingAnchor.constraint(equalTo: numberViewContainer.leadingAnchor),
            numberView.trailingAnchor.constraint(equalTo: numberViewContainer.trailingAnchor)
        ])

        return numberViewContainer
    }

    func getFlagView(accountNumber: AccountNumber) -> UIView {
        let flag = Flag(countryCode: accountNumber.countryCode)
        let imageView = UIImageView(image: flag?.image(style: .none))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return imageView
    }

    func getNumberLabel(accountNumber: AccountNumber) -> UIView {
        let numberLabel = UILabel()
        numberLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 14) : .systemFont(ofSize: 18)
        numberLabel.textColor = .black
        numberLabel.textAlignment = .left
        numberLabel.text = accountNumber.number

        return numberLabel
    }

    func getNumberInfoView(accountNumber: AccountNumber) -> UIView {
        let numberMessagesLabel = UILabel()
        let numberRecentsLabel = UILabel()

        numberMessagesLabel.text = "\(NSLocalizedString("label.profile.number.messages", comment: "")): \(0)"
        numberMessagesLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 12) : .systemFont(ofSize: 14)
        numberMessagesLabel.textColor = .grayLightA2
        numberMessagesLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        numberRecentsLabel.text = "\(NSLocalizedString("label.profile.number.recents", comment: "")): \(0)"
        numberRecentsLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 12) : .systemFont(ofSize: 14)
        numberRecentsLabel.textColor = .grayLightA2

        let numberInfoView = UIStackView(arrangedSubviews: [numberMessagesLabel, numberRecentsLabel])
        numberInfoView.setCustomSpacing(10, after: numberMessagesLabel)
        numberInfoView.axis = .horizontal
        numberInfoView.distribution = .fill
        numberInfoView.translatesAutoresizingMaskIntoConstraints = false

        return numberInfoView
    }

    func getNumberTag(accountNumber: AccountNumber) -> UIView {
        let numberTagView = TagLabel()
        numberTagView.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 10) : .systemFont(ofSize: 12)
        numberTagView.textColor = .white

        numberTagView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        if accountNumber.isActive {
            numberTagView.backgroundColor = .darkBlue
            numberTagView.text = NSLocalizedString("label.number.active", comment: "")
        } else {
            numberTagView.backgroundColor = .grayLightA1
            numberTagView.text = NSLocalizedString("label.number.not.active", comment: "")
        }

        return numberTagView
    }

}
