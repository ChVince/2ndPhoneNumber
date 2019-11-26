//
//  File.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit
import SafariServices

protocol SubscriptionPageActionsProtcol: AnyObject {
    func presentTermsPage()
    func presentPrivacyPage()
    func onRestoreTap()
    func onSubscribeTap()
    func onDoneTap()
    func onPageControlChange(nextIndexPath: IndexPath)
}

struct SubscriptionPageData {
    var imageName: String
    var imageTitle: String
    var description: String
}

class SubscribeViewHeader: UIView {
    var restoreButton: UIButton!
    var closeButton: UIButton!

    weak var delegate: SubscriptionPageActionsProtcol!

    override init(frame: CGRect) {
        super.init(frame: frame);

        setupLayout()
        setupHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        restoreButton = setupRestoreButton()
        closeButton = setupCloseButton()

        setupButtonsView()
    }

    func setupHandlers() {
        restoreButton.addTarget(self, action: #selector(self.onRestoreButtonTap(sender:)), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(self.onCloseButtonTap(sender:)), for: .touchUpInside)
    }

    func setupRestoreButton() -> UIButton {
        let restoreButton = UIButton()
        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        restoreButton.setTitle(NSLocalizedString("label.subscribe.restore", comment: ""), for: .normal)
        restoreButton.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        restoreButton.setTitleColor(.black, for: .normal)

        return restoreButton
    }

    func setupCloseButton() -> UIButton {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close"), for: .normal)

        return closeButton
    }

    func setupButtonsView() {
        let buttonsView = UIStackView()
        buttonsView.axis = .horizontal
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.distribution = .equalSpacing
        buttonsView.alignment = .center

        buttonsView.addArrangedSubview(restoreButton)
        buttonsView.addArrangedSubview(closeButton)
        self.addSubview(buttonsView)

        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: self.topAnchor),
            buttonsView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            buttonsView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            buttonsView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }


    @objc func onRestoreButtonTap(sender: UIButton) {
        self.delegate.onRestoreTap()
    }

    @objc func onCloseButtonTap(sender: UIButton) {
        self.delegate.onDoneTap()
    }
}

class SubscribeViewFooter: UIView {
    let NUMBER_OF_PAGES = 4

    var currentPage = 0 {
        didSet {
            updatePageControlIndicator()
        }
    }
    var pageControl: UIPageControl!
    var subscribeButton: UIButton!
    var termsOfUseButton: UIButton!
    var privacyButton: UIButton!

    weak var delegate: SubscriptionPageActionsProtcol!

    override init(frame: CGRect) {
        super.init(frame: frame);

        setupViews()
        setupHandlers()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 0.15),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            subscribeButton.widthAnchor.constraint(equalToConstant: self.frame.width * 0.6),
            subscribeButton.heightAnchor.constraint(equalToConstant: self.frame.height * 0.18),
            subscribeButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: self.frame.height * 0.1),
            subscribeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        subscribeButton.layer.cornerRadius = subscribeButton.frame.height / 2
    }

    func setupViews() {
        pageControl = setupPageControl()
        subscribeButton = setupSubscribeButton()
        termsOfUseButton = setupTermsOfUseButton()
        privacyButton = setupPrivacyButton()

        setupSubscribeLabel()
        setupSubcribeBottomLabels()
    }

    func setupHandlers() {
        pageControl.addTarget(self, action: #selector(onControlTap), for: .allEvents)
        subscribeButton.addTarget(self, action: #selector(onSubscribeTap), for: .touchUpInside)
        termsOfUseButton.addTarget(self, action: #selector(onTermsTap), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(onPrivacyTap), for: .touchUpInside)
    }

    func setupPageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.currentPage = currentPage
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = NUMBER_OF_PAGES
        pageControl.currentPageIndicatorTintColor = .darkBlue
        pageControl.pageIndicatorTintColor = .darkBlueWithOpacity

        self.addSubview(pageControl)

        return pageControl
    }

    func setupSubscribeButton() -> UIButton {
        let subscribeButton = UIButton(type: .system)
        subscribeButton.setTitle(NSLocalizedString("label.subscribe.subscribe", comment: "").uppercased(), for: .normal)
        subscribeButton.titleLabel!.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 14, weight: .medium): UIFont.systemFont(ofSize: 16, weight: .medium)
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.backgroundColor = UIColor.darkBlue
        subscribeButton.setTitleColor(.white, for: .normal)

        self.addSubview(subscribeButton)
        return subscribeButton
    }

    func setupSubscribeLabel() {
        let subscribeButtonLabel = UILabel()
        subscribeButtonLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 12, weight: .light) : UIFont.systemFont(ofSize: 14, weight: .light)
        subscribeButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        subscribeButtonLabel.text = NSLocalizedString("label.subscribe.offer", comment: "")
        subscribeButtonLabel.textColor = .grayLightA1

        self.addSubview(subscribeButtonLabel)
        NSLayoutConstraint.activate([
            subscribeButtonLabel.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 15),
            subscribeButtonLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setupTermsOfUseButton() -> UIButton {
        let termOfUseButton = UIButton()

        let attributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 10, weight: .light) : UIFont.systemFont(ofSize: 12, weight: .light),
            NSAttributedString.Key.foregroundColor : UIColor.grayLightA1,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]

        termOfUseButton.setAttributedTitle(NSAttributedString(string: NSLocalizedString("label.subscribe.terms.of.use", comment: ""), attributes: attributes), for: .normal)
        termOfUseButton.backgroundColor = .white

        return termOfUseButton
    }

    func setupPrivacyButton() -> UIButton {
        let privacyButton = UIButton()

        let attributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 10, weight: .light) : UIFont.systemFont(ofSize: 12, weight: .light),
            NSAttributedString.Key.foregroundColor : UIColor.grayLightA1,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]

        privacyButton.setAttributedTitle(NSAttributedString(string: NSLocalizedString("label.subscribe.privacy", comment: ""), attributes: attributes), for: .normal)
        privacyButton.backgroundColor = .white

        return privacyButton
    }

    func setupSubcribeBottomLabels() {
        let subscribeBottomLabels = UIStackView(arrangedSubviews: [termsOfUseButton, privacyButton])
        subscribeBottomLabels.axis = .horizontal
        subscribeBottomLabels.distribution = .fillProportionally
        subscribeBottomLabels.spacing = 1

        subscribeBottomLabels.translatesAutoresizingMaskIntoConstraints = false

        let subscribeBottomLabelsContainer = UIView()
        subscribeBottomLabelsContainer.backgroundColor = .grayLightA1
        subscribeBottomLabelsContainer.translatesAutoresizingMaskIntoConstraints = false
        subscribeBottomLabelsContainer.addSubview(subscribeBottomLabels)

        NSLayoutConstraint.activate([
            subscribeBottomLabels.heightAnchor.constraint(equalToConstant: 15),
            subscribeBottomLabels.widthAnchor.constraint(equalToConstant: 180),
            subscribeBottomLabels.bottomAnchor.constraint(equalTo: subscribeBottomLabelsContainer.bottomAnchor, constant: 0),
            subscribeBottomLabels.centerXAnchor.constraint(equalTo: subscribeBottomLabelsContainer.centerXAnchor)
        ])

        self.addSubview(subscribeBottomLabelsContainer)

        NSLayoutConstraint.activate([
            subscribeBottomLabelsContainer.heightAnchor.constraint(equalToConstant: 15),
            subscribeBottomLabelsContainer.widthAnchor.constraint(equalToConstant: 180),
            subscribeBottomLabelsContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            subscribeBottomLabelsContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func updatePageControlIndicator() {
        pageControl.currentPage = currentPage
    }

    @objc func onControlTap() {
        delegate.onPageControlChange(nextIndexPath: IndexPath(item: self.currentPage, section: 0))
    }

    @objc func onSubscribeTap() {
        delegate.onSubscribeTap()
    }

    @objc func onTermsTap() {
        delegate.presentTermsPage()
    }

    @objc func onPrivacyTap() {
        delegate.presentPrivacyPage()
    }
}

class SubscribeViewPageCell: UICollectionViewCell {
    var subscriptionPageData: SubscriptionPageData! {
        didSet {
            setupPageData()
        }
    }

    @UsesAutoLayout
    var imageView = UIImageView()

    @UsesAutoLayout
    var imageTitleView = UILabel()

    @UsesAutoLayout
    var imageDescriptionView = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame);

        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        setupImageView()
        setupImageTitle()
        setupDescription()
    }

    func setupLayout() {
        imageView.setAnchors(top: self.topAnchor, padding: UIEdgeInsets(top: self.frame.height * 0.15, left: 0, bottom: 0, right: 0))
        imageView.alignXCenter()
        imageView.setSize(width: self.frame.width * 0.5, height: self.frame.width * 0.5)

        imageTitleView.alignXYCenter()

        let topPadding = CGFloat(UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 0.0 : 12.0)
        imageDescriptionView.setAnchors(top: imageTitleView.bottomAnchor, padding: UIEdgeInsets(top: topPadding, left: 0, bottom: 0, right: 0))
        imageDescriptionView.alignXCenter()
    }

    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }

    func setupImageTitle() {
        imageTitleView.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont(name: "Circe-Bold", size: 28): UIFont(name: "Circe-Bold", size: 33)
        imageTitleView.textColor = .darkBlue
        imageTitleView.textAlignment = .center

        self.addSubview(imageTitleView)
    }

    func setupDescription() {
        imageDescriptionView.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 12, weight: .regular) : UIFont.systemFont(ofSize: 14, weight: .regular)
        imageDescriptionView.textColor = .black
        imageDescriptionView.textAlignment = .center

        self.addSubview(imageDescriptionView)
    }

    func setupPageData() {
        imageView.image = UIImage(named: subscriptionPageData.imageName)
        imageTitleView.text = subscriptionPageData.imageTitle
        imageDescriptionView.text = subscriptionPageData.description
    }
}

class SubscribeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SubscriptionPageActionsProtcol {
     let subscriptionPageDataList = [SubscriptionPageData]([
        SubscriptionPageData(imageName: "realNumber", imageTitle: "Real Number", description: "Contact anyone with your real number"),
        SubscriptionPageData(imageName: "zeroAds", imageTitle: "Zero ads", description: "Enjoy the complete ad-free experience"),
        SubscriptionPageData(imageName: "anonymous", imageTitle: "Completely anonymous", description: "Call and send text securely"),
        SubscriptionPageData(imageName: "internationalAccess", imageTitle: "International access", description: "Text and call country internationally")
    ])

    @UsesAutoLayout
    var subscribeHeader = SubscribeViewHeader()

    @UsesAutoLayout
    var subscribeFooter = SubscribeViewFooter()

    var subscribeViewModel = SubscribeViewModel()

    var delegate: ModalHandler!

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white

        setupViews()
        setupLayout()
    }

    func setupViews() {
        setupCollectionView()
        setupViewHeader()
        setupViewFooter()
    }

    func setupLayout() {
        subscribeHeader.setAnchors(top: self.view.safeAreaLayoutGuide.topAnchor)
        subscribeHeader.setSize(width: self.view.frame.size.width, height: 50)

        subscribeFooter.setAnchors(top: self.view.safeAreaLayoutGuide.bottomAnchor)
        subscribeFooter.setSize(width: self.view.frame.width, height: self.view.frame.height * 0.4)
    }

    func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(SubscribeViewPageCell.self, forCellWithReuseIdentifier: String(describing: SubscribeViewPageCell.self))
    }

    func setupViewHeader() {
        subscribeHeader.delegate = self
        view.addSubview(subscribeHeader)
    }

    func setupViewFooter() {
        subscribeFooter.delegate = self
        view.addSubview(subscribeFooter)
    }
}

extension SubscribeViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptionPageDataList.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SubscribeViewPageCell.self), for: indexPath) as! SubscribeViewPageCell
        cellView.subscriptionPageData = subscriptionPageDataList[indexPath.item]
        return cellView
    }

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        subscribeFooter.currentPage = Int(targetContentOffset.pointee.x / view.frame.width)
    }

    func presentTermsPage() {
        present(SFSafariViewController(url: subscribeViewModel.getTermsOfUseURL()), animated: true)
    }

    func presentPrivacyPage() {
        present(SFSafariViewController(url: subscribeViewModel.getPrivacyPolicyURL()), animated: true)
    }

    func onRestoreTap() {
        subscribeViewModel.restoreSubscription()
    }

    func onSubscribeTap() {
        subscribeViewModel.performSubscription()
    }

    func onPageControlChange(nextIndexPath: IndexPath) {
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }

    func onDoneTap() {
        self.dismiss(animated: true) {
            self.delegate.modalDismissed()
        }
    }

}
