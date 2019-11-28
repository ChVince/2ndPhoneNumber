//
//  HistoryListViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 03.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class RecentCallsViewCell: UITableViewCell {
    @UsesAutoLayout
    var callDateLabelView = UILabel()

    @UsesAutoLayout
    var callInfoIconView = UIButton(type: .custom)

    var delegate: RecentCallsViewController!

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

        setupContactLabelView()
        setupCallInfoIconView()
        setupCallDateLabelView()

        setupLayout()

        self.callInfoIconView.addTarget(self, action: #selector(self.onInfoTouch(sender:)), for: .touchUpInside)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 22, y: 12, width: 40, height: 40)
        textLabel?.frame = CGRect(x: 75, y: 14, width: textLabel!.intrinsicContentSize.width, height:  textLabel!.intrinsicContentSize.height)
        detailTextLabel?.frame = CGRect(x: 75, y: 34, width: detailTextLabel!.intrinsicContentSize.width, height:  detailTextLabel!.intrinsicContentSize.height)

        self.imageView?.makeRounded()
    }

    func setupContactLabelView() {
        textLabel?.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 14, weight: .bold) : UIFont.systemFont(ofSize: 16, weight: .bold)
        textLabel?.textColor = .black
    }

    func setupCallInfoIconView() {
        let image = UIImage(named: "info")
        callInfoIconView.setImage(image, for: .normal)

        self.addSubview(callInfoIconView)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            callInfoIconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            callInfoIconView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            callInfoIconView.widthAnchor.constraint(equalToConstant: callInfoIconView.intrinsicContentSize.width),
            callInfoIconView.heightAnchor.constraint(equalToConstant: callInfoIconView.intrinsicContentSize.height)
        ])
        NSLayoutConstraint.activate([
            callDateLabelView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            callDateLabelView.trailingAnchor.constraint(equalTo: callInfoIconView.leadingAnchor, constant: -5),
            callDateLabelView.heightAnchor.constraint(equalToConstant: callInfoIconView.intrinsicContentSize.height)
        ])
    }

    func setupCallDateLabelView() {
        callDateLabelView.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 10) : UIFont.systemFont(ofSize: 12)
        callDateLabelView.textColor = .systemGray
        self.addSubview(callDateLabelView)
    }

    func setupCellData() {
        imageView!.image = UIImage(named: recentCellData.contact.image!)
        textLabel!.text = recentCellData.contact.getContactName()
        callDateLabelView.text = recentCellData.call.date.format()

        setupCallStatusLabelViewData()
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

        detailTextLabel!.attributedText = callLabel
    }

    @objc func onInfoTouch(sender: UITapGestureRecognizer) {
        delegate.navigateToRecentCall(recentCellData: recentCellData)
    }
}

class RecentCallsViewController: AccountDropdownNavigationController {
    var recentCallsViewModel: RecentCallsViewModel!

    @UsesAutoLayout
    var recentCallsFilterView = UISegmentedControl(items: [
        NSLocalizedString("label.account.calls.all", comment: ""),
        NSLocalizedString("label.account.calls.missed", comment: "")
    ])

    @UsesAutoLayout
    var recentsFilterViewContainer = UIView()

    @UsesAutoLayout
    var tableView = UITableView()

    override func loadView() {
        super.loadView()

        setupRecentCallsFilterView()
        setupTableView()

        setupLayout()

        setupHandlers()
    }

    func setupRecentCallsFilterView() {
        recentCallsFilterView.selectedSegmentIndex = 0
        recentsFilterViewContainer.backgroundColor = .white

        view.addSubview(recentsFilterViewContainer)
        recentsFilterViewContainer.addSubview(recentCallsFilterView)

        recentCallsFilterView.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ], for: .normal)

        recentCallsFilterView.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ], for: .selected)
    }

    func setupTableView() {
        tableView.register(RecentCallsViewCell.self, forCellReuseIdentifier: String(describing: RecentCallsViewCell.self))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.rowHeight = 64

        view.addSubview(tableView)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            recentsFilterViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recentsFilterViewContainer.widthAnchor.constraint(equalToConstant: view.frame.width),
            recentsFilterViewContainer.heightAnchor.constraint(equalToConstant: 45)
        ])

        NSLayoutConstraint.activate([
            recentCallsFilterView.centerXAnchor.constraint(equalTo: recentsFilterViewContainer.centerXAnchor),
            recentCallsFilterView.topAnchor.constraint(equalTo: recentsFilterViewContainer.topAnchor, constant: 10),
            recentCallsFilterView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            recentCallsFilterView.heightAnchor.constraint(equalToConstant: 25)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: recentsFilterViewContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupHandlers() {
        recentCallsFilterView.addTarget(self, action: #selector(self.onFilterValueChange), for: .valueChanged)
    }

    @objc func onFilterValueChange() {
        let index = recentCallsFilterView.selectedSegmentIndex
        if index == 0 {
            recentCallsViewModel.isFiltered = false
        }

        if index == 1 {
            recentCallsViewModel.isFiltered = true
        }

        tableView.reloadData()
    }
}

extension RecentCallsViewController: UITableViewDataSource, UITableViewDelegate  {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentCallsViewModel.getRecentCellDataList().count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecentCallsViewCell.self), for: indexPath) as! RecentCallsViewCell
        cell.recentCellData = recentCallsViewModel.getRecentCellDataList()[indexPath.item]
        cell.delegate = self

        return cell
    }

    func navigateToRecentCall(recentCellData: RecentCellData) {
        let callViewController = RecentViewController()
        navigationController?.pushViewController(callViewController, animated: true)
        callViewController.contactsViewModel = ContactsViewModel(accountViewModel: accountViewModel)
    }

     func updateSearchResults(for searchController: UISearchController) {
         // TODO implement
     }
}
