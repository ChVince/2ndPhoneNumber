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
                self.imageView?.transform = .identity
            } else {
                self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
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

        self.setTitle("XXXxxxxxxX", for: .normal)

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

final class AccountNavigationDropdownTable: UITableView, UITableViewDelegate, UITableViewDataSource {

    weak var navigationBarDropdownDelegate: NavigationBarDropdownDelegate!

    var accountViewModel: AccountViewModel! {
        didSet {
            self.reloadData()
        }
    }

    override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)

        self.register(AccountNavigationDropdownCell.self, forCellReuseIdentifier: String(describing: AccountNavigationDropdownCell.self))
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel.accountNumbers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: String(describing: AccountNavigationDropdownCell.self)), for: indexPath) as! AccountNavigationDropdownCell

        cell.accountNumber = accountViewModel.accountNumbers[indexPath.item]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AccountNavigationDropdownCell
        tableView.deselectRow(at: indexPath, animated: false)

        accountViewModel.setActiveNumber(number: cell.accountNumber.number)

        navigationBarDropdownDelegate.updateDropdownTitle()
        navigationBarDropdownDelegate.toggleDropdown()

        self.reloadData()
    }

    @objc func onBackgroundTap() {
        navigationBarDropdownDelegate.toggleDropdown()
    }
}

class AccountDropdownNavigationController: UIViewController {
    var isDropdownShown = false
    var accountNavigationDropdownButton = AccountNavigationDropdownButton()

    @UsesAutoLayout
    var accountNavigationDropdownTable = AccountNavigationDropdownTable()

    var accountViewModel: AccountViewModel!

    override func loadView() {
        super.loadView()

        self.navigationItem.titleView = accountNavigationDropdownButton
        accountNavigationDropdownButton.delegate = self

        accountNavigationDropdownTable.accountViewModel = accountViewModel
        accountNavigationDropdownTable.navigationBarDropdownDelegate = self

        view.addSubview(accountNavigationDropdownTable)

        accountNavigationDropdownTable.setSize(width: view.frame.width, height: view.frame.height)
        accountNavigationDropdownTable.alignXCenter()
        NSLayoutConstraint.activate([
            accountNavigationDropdownTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
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
