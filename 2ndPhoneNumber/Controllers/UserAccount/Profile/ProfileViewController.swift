//
//  ProfileViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 06.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit
import FlagKit

private struct MenuItemDescription {
    var itemId: Int
    var imageName: String
    var menuLabel: String
}

class ProfileViewController: UIViewController {
    var accountViewModel: AccountViewModel!
    let PRIVACY_URL = URL(string: "https://google.com")!
    let SUPPORT_URL = URL(string: "https://google.com")!
    let TERMS_URL = URL(string: "https://google.com")!

    private let menuDescriptionList = [
        MenuItemDescription(itemId: 0, imageName: "privacy", menuLabel: NSLocalizedString("label.profile.privacy", comment: "")),
        MenuItemDescription(itemId: 1, imageName: "terms", menuLabel: NSLocalizedString("label.profile.terms.of.use", comment: "")),
        MenuItemDescription(itemId: 2, imageName: "support", menuLabel: NSLocalizedString("label.profile.support", comment: "")),
        MenuItemDescription(itemId: 3, imageName: "share", menuLabel: NSLocalizedString("label.profile.share", comment: ""))
    ]

    var numberListView: UIView!
    var topBallanceButton: UIButton!
    var scrollView: UIScrollView!

    override func loadView() {
        super.loadView()

        scrollView = setupScrollView()
        numberListView = setupNumberListView()
        topBallanceButton = setupTopBallanceButton()

        setupNavigationItem()
        setupMenuView()

        topBallanceButton.addTarget(self, action: #selector(self.onTopBallanceTap(sender:)), for: .touchUpInside)
    }

    func setupNumberListView() -> UIView {
        let numberListView = UIStackView()
        numberListView.axis = .vertical
        numberListView.translatesAutoresizingMaskIntoConstraints = false
        numberListView.spacing = 0
        numberListView.alignment = .center

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

        return numberListViewContainer
    }

    func setupTopBallanceButton() -> UIButton {
        let topBalanceButtonContainer = UIView()
        topBalanceButtonContainer.backgroundColor = .white
        topBalanceButtonContainer.translatesAutoresizingMaskIntoConstraints = false

        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("label.profile.balance", comment: "").uppercased(), for: .normal)
        button.titleLabel!.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 12, weight:.medium) : UIFont.systemFont(ofSize: 14, weight:.medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.darkBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 15

        topBalanceButtonContainer.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topBalanceButtonContainer.topAnchor, constant: 5),
            button.centerXAnchor.constraint(equalTo: topBalanceButtonContainer.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])

        scrollView.addSubview(topBalanceButtonContainer)

        NSLayoutConstraint.activate([
            topBalanceButtonContainer.topAnchor.constraint(equalTo: numberListView.bottomAnchor),
            topBalanceButtonContainer.widthAnchor.constraint(equalToConstant: view.frame.width),
            topBalanceButtonContainer.heightAnchor.constraint(equalToConstant: 50),
        ])

        return button
    }

    func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return scrollView
    }

    func setupMenuView() {
        let menuView = UIStackView()
        menuView.spacing = 1
        menuView.axis = .vertical
        menuView.alignment = .center
        menuView.translatesAutoresizingMaskIntoConstraints = false

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
            menuView.topAnchor.constraint(equalTo: topBallanceButton.bottomAnchor, constant: 30),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            menuView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    func setupNavigationItem() {
        self.navigationItem.title = NSLocalizedString("label.profile.title", comment: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGrayF2
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

        assignHandlerToMenuItem(menuItemViewContainer: menuItemViewContainer, menuItemDescription: menuItemDescription)
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

    fileprivate func assignHandlerToMenuItem(menuItemViewContainer: UIView, menuItemDescription: MenuItemDescription) {
        let tapGesture: UITapGestureRecognizer
        switch menuItemDescription.itemId {
        case 0:
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPrivacyTap(sender:)))
        case 1:
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTermsTap(sender:)))
        case 2:
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(onSupportTap(sender:)))
        case 3:
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(onShareTap(sender:)))
        default:
            return
        }

        menuItemViewContainer.addGestureRecognizer(tapGesture)
    }

    @objc func onPrivacyTap(sender: UITapGestureRecognizer) {
        present(PrivacyViewController(url: PRIVACY_URL), animated: true)
    }   

    @objc func onTermsTap(sender: UITapGestureRecognizer) {
        present(TermsViewController(url: TERMS_URL), animated: true)
    }

    @objc func onSupportTap(sender: UITapGestureRecognizer) {
        present(SupportViewController(url: SUPPORT_URL), animated: true)
    }

    @objc func onShareTap(sender: UITapGestureRecognizer) {

    }

    @objc func onTopBallanceTap(sender: UIButton) {

    }

}
