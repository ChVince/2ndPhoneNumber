//
//  AccountNavigationDropdown.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 22.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

final class AccountNavigationDropdownButton: UIButton {

    weak var delegate: NavigationBarDropdownDelegate! {
        didSet {
            self.delegate.updateDropdownTitle()
        }
    }

    var isDropdownShown = false {
        didSet {
            if self.isDropdownShown {
                self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            } else {
                self.imageView?.transform = .identity
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame);

        self.setImage(UIImage(named: "collapsed"), for: .normal)
        self.semanticContentAttribute = .forceRightToLeft

        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 18)
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)

        self.addTarget(self, action: #selector(onToggleTap(sender:)), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onToggleTap(sender: UIButton) {
        self.delegate.toggleDropdown()
    }
}

final class AccountNavigationDropdownCell: UITableViewCell {
    weak var accountNumber: AccountNumber! {
        didSet {
            setupCellData()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.font = .systemFont(ofSize: 18)
        textLabel?.textColor = .black
        textLabel?.textAlignment = .center
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.alignXYCenter()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupCellData() {
        textLabel?.text = accountNumber.number

        if accountNumber.isActive {
            textLabel?.textColor = .darkBlue
            imageView?.image = UIImage(named: "checked")
        } else {
            textLabel?.textColor = .black
            imageView?.image = .none
        }
    }
}

final class AccountNavigationDropdownExtraCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let addNumberText: NSAttributedString
        let addNumberImage = NSTextAttachment()

        addNumberText = NSAttributedString(string: NSLocalizedString("label.navigation.dropdown.number.add", comment: ""), attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.darkBlue
        ])
        addNumberImage.image = UIImage(named: "add")

        let addNumberLine = NSMutableAttributedString()
        addNumberLine.append(NSAttributedString(attachment: addNumberImage))
        addNumberLine.append(NSAttributedString(string: " "))
        addNumberLine.append(addNumberText)

        textLabel!.attributedText = addNumberLine
        textLabel!.translatesAutoresizingMaskIntoConstraints = false
        textLabel!.alignXYCenter()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

final class AccountNavigationDropdownTable: UITableView {

    weak var navigationBarDropdownDelegate: NavigationBarDropdownDelegate!

    var accountViewModel: AccountViewModel! {
        didSet {
            self.reloadData()
        }
    }

    override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)

        self.register(AccountNavigationDropdownCell.self, forCellReuseIdentifier: String(describing: AccountNavigationDropdownCell.self))
        self.register(AccountNavigationDropdownExtraCell.self, forCellReuseIdentifier: String(describing: AccountNavigationDropdownExtraCell.self))

        self.tableFooterView = UIView()
        self.rowHeight = 56
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        self.backgroundColor = .clear
        self.alwaysBounceVertical = false;
        self.isHidden = true

        self.delegate = self
        self.dataSource = self


        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.backgroundView = blurEffectView

        let tap = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTap))
        self.backgroundView?.addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onBackgroundTap() {
        navigationBarDropdownDelegate.toggleDropdown()
    }

}

extension AccountNavigationDropdownTable: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel.accountNumbers.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.item == accountViewModel.accountNumbers.count {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: String(describing: AccountNavigationDropdownExtraCell.self)), for: indexPath) as! AccountNavigationDropdownExtraCell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: String(describing: AccountNavigationDropdownCell.self)), for: indexPath) as! AccountNavigationDropdownCell

        cell.accountNumber = accountViewModel.accountNumbers[indexPath.item]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.item == accountViewModel.accountNumbers.count {
            //
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! AccountNavigationDropdownCell
            accountViewModel.setActiveNumber(number: cell.accountNumber.number)
        }

        tableView.deselectRow(at: indexPath, animated: false)
        navigationBarDropdownDelegate.updateDropdownTitle()
        navigationBarDropdownDelegate.toggleDropdown()

        self.reloadData()
    }
}


class AccountDropdownNavigationController: UIViewController {
    var isDropdownShown = false

    @UsesAutoLayout
    var accountNavigationDropdownButton = AccountNavigationDropdownButton()

    @UsesAutoLayout
    var accountNavigationDropdownTable = AccountNavigationDropdownTable()

    var accountViewModel: AccountViewModel!

    override func loadView() {
        super.loadView()

        setupDropdownButton()
        setupDropdownTable()

        setupDropdownLayout()
    }

    private func setupDropdownButton() {
        self.navigationItem.titleView = accountNavigationDropdownButton
        accountNavigationDropdownButton.delegate = self
    }

    private func setupDropdownTable() {
        accountNavigationDropdownTable.accountViewModel = accountViewModel
        accountNavigationDropdownTable.navigationBarDropdownDelegate = self

        view.addSubview(accountNavigationDropdownTable)
    }

    private func setupDropdownLayout() {
        NSLayoutConstraint.activate([
            accountNavigationDropdownTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            accountNavigationDropdownTable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            accountNavigationDropdownTable.widthAnchor.constraint(equalToConstant: view.frame.width),
            accountNavigationDropdownTable.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])

        NSLayoutConstraint.activate([
            accountNavigationDropdownButton.centerXAnchor.constraint(equalTo: accountNavigationDropdownButton.superview!.centerXAnchor),
            accountNavigationDropdownButton.centerYAnchor.constraint(equalTo: accountNavigationDropdownButton.superview!.centerYAnchor),
            accountNavigationDropdownButton.widthAnchor.constraint(equalToConstant: 200),
            accountNavigationDropdownButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

extension AccountDropdownNavigationController: NavigationBarDropdownDelegate {//refactor
    func updateDropdownTitle() {
        let number = accountViewModel.getActiveNumber().number
        accountNavigationDropdownButton.setTitle(number, for: .normal)
    }

    func toggleDropdown() {
        self.isDropdownShown = !self.isDropdownShown
        accountNavigationDropdownButton.isDropdownShown = self.isDropdownShown
        accountNavigationDropdownTable.isHidden = !self.isDropdownShown
        view.bringSubviewToFront(accountNavigationDropdownTable)
    }

}
