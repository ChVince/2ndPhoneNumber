//
//  HistoryListViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class RecentCallsViewCell: UITableViewCell {
    var contactImageView: UIImageView!
    var contactLabelView: UILabel!
    var callStatusLabelView: UILabel!
    var callDateLabelView: UILabel!
    var callInfoIconView: UIButton!
    var navigationController: UINavigationController!// refactor
    var accountViewModel: AccountViewModel!// refactor

    var recentCellData: RecentCellData! {
        didSet {
            setupCellData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        self.contactImageView = setupContactImageView()
        self.contactLabelView = setupContactLabelView()
        self.callInfoIconView = setupCallInfoIconView()
        self.callDateLabelView = setupCallDateLabelView()
        self.callStatusLabelView = setupCallStatusLabelView()

        self.callInfoIconView.addTarget(self, action: #selector(self.onInfoTouch(sender:)), for: .touchUpInside)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 22, y: 12, width: 40, height: 40)
        textLabel?.frame = CGRect(x: 75, y: 14, width: textLabel!.intrinsicContentSize.width, height:  textLabel!.intrinsicContentSize.height)
        detailTextLabel?.frame = CGRect(x: 75, y: 34, width: textLabel!.intrinsicContentSize.width, height:  textLabel!.intrinsicContentSize.height)
        self.imageView?.makeRounded()
    }

    func setupContactImageView() -> UIImageView {
        return imageView!
    }

    func setupContactLabelView() -> UILabel {
        textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textLabel?.textColor = .black

        return textLabel!
    }

    func setupCallStatusLabelView() -> UILabel {
         return detailTextLabel!
    }

    func setupCallStatusLabelViewData() {
        let callLabelText: NSAttributedString
        let callLabelImage = NSTextAttachment()

        switch recentCellData.call.status {
        case .INCOMING:
            callLabelText = NSAttributedString(string: NSLocalizedString("label.profile.number.incoming", comment: ""), attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray
            ])
            callLabelImage.image = UIImage(named: "incoming")
            break
        case .OUTGOING:
            callLabelText = NSAttributedString(string: NSLocalizedString("label.profile.number.outgoing", comment: ""), attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray
            ])
            callLabelImage.image = UIImage(named: "outgoing")
            break;
        case .MISSED:
            callLabelText = NSAttributedString(string: NSLocalizedString("label.profile.number.missed", comment: ""), attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.red
            ])
            callLabelImage.image = UIImage(named: "missed")
            break;
        case .CANCELLED:
            callLabelText = NSAttributedString(string: NSLocalizedString("label.profile.number.cancelled", comment: ""), attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.red
            ])
            callLabelImage.image = UIImage(named: "cancelled")
            break;
        }

        let callLabel = NSMutableAttributedString()
        callLabel.append(NSAttributedString(attachment: callLabelImage))
        callLabel.append(NSAttributedString(string: " "))
        callLabel.append(callLabelText)

        callStatusLabelView.attributedText = callLabel
    }
    func setupCallInfoIconView() -> UIButton {
        let image = UIImage(named: "info")
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(image, for: .normal)

        infoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(infoButton)

        NSLayoutConstraint.activate([
            infoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            infoButton.widthAnchor.constraint(equalToConstant: infoButton.intrinsicContentSize.width),
            infoButton.heightAnchor.constraint(equalToConstant: infoButton.intrinsicContentSize.height)
        ])

        return infoButton
    }
    func setupCallDateLabelView() -> UILabel {
        let callDateLabelView = UILabel()
        callDateLabelView.font = .systemFont(ofSize: 12)
        callDateLabelView.textColor = .systemGray
        callDateLabelView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(callDateLabelView)
        NSLayoutConstraint.activate([
            callDateLabelView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            callDateLabelView.trailingAnchor.constraint(equalTo: callInfoIconView.leadingAnchor, constant: -5),
            callDateLabelView.heightAnchor.constraint(equalToConstant: callInfoIconView.intrinsicContentSize.height)
        ])

        return callDateLabelView
    }
    func setupCellData() {
        contactImageView.image = UIImage(named: recentCellData.contact.image)
        contactLabelView.text = recentCellData.contact.getContactName()
        callDateLabelView.text = recentCellData.call.getDate()

        setupCallStatusLabelViewData()
    }

    @objc func onInfoTouch(sender: UITapGestureRecognizer) {
        let callViewController = RecentViewController()
        navigationController?.pushViewController(callViewController, animated: true)
        callViewController.accountViewModel = accountViewModel
    }
}

class RecentCallsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var accountViewModel: AccountViewModel!
    var recentCallsFilterView: UISegmentedControl!
    var tableView: UITableView!

    override func loadView() {
        super.loadView()
        self.recentCallsFilterView = setupRecentCallsFilterView()
        self.tableView = setupTableView()
        setupNavigationItem()
    }

    func setupRecentCallsFilterView() -> UISegmentedControl {
        let recentsFilterView = UISegmentedControl(items: [
            NSLocalizedString("label.account.calls.all", comment: ""),
            NSLocalizedString("label.account.calls.missed", comment: "")
        ])

        recentsFilterView.selectedSegmentIndex = 0

        let recentsFilterViewContainer = UIView()
        recentsFilterViewContainer.translatesAutoresizingMaskIntoConstraints = false
        recentsFilterView.translatesAutoresizingMaskIntoConstraints = false
        recentsFilterViewContainer.backgroundColor = .white

        view.addSubview(recentsFilterViewContainer)
        recentsFilterViewContainer.addSubview(recentsFilterView)

        NSLayoutConstraint.activate([
            recentsFilterViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recentsFilterViewContainer.widthAnchor.constraint(equalToConstant: view.frame.width),
            recentsFilterViewContainer.heightAnchor.constraint(equalToConstant: 45)
        ])

        NSLayoutConstraint.activate([
            recentsFilterView.centerXAnchor.constraint(equalTo: recentsFilterViewContainer.centerXAnchor),
            recentsFilterView.topAnchor.constraint(equalTo: recentsFilterViewContainer.topAnchor, constant: 10),
            recentsFilterView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            recentsFilterView.heightAnchor.constraint(equalToConstant: 25)
        ])

       recentsFilterView.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ], for: .normal)

        recentsFilterView.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ], for: .selected)

        return recentsFilterView
    }

    func setupTableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(RecentCallsViewCell.self, forCellReuseIdentifier: String(describing: RecentCallsViewCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.rowHeight = 65

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: recentCallsFilterView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.reloadData()
        return tableView
    }

    func setupNavigationItem() {
        self.navigationItem.title = NSLocalizedString("label.account.calls.title", comment: "")
    }
}

extension RecentCallsViewController {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel.recentsCellDataList.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecentCallsViewCell.self), for: indexPath) as! RecentCallsViewCell
        cell.recentCellData = accountViewModel.recentsCellDataList[indexPath.item]
        cell.navigationController = self.navigationController
        cell.accountViewModel = self.accountViewModel
        return cell
    }

     func updateSearchResults(for searchController: UISearchController) {
         // TODO implement
     }
}
