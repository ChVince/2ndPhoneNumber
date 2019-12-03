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

    @UsesAutoLayout
    var pageControl = UIPageControl()

    @UsesAutoLayout
    var subscribeButton = UIRoundedButton()

    @UsesAutoLayout
    var subscribeButtonLabel = UILabel()

    @UsesAutoLayout
    var subscribeFooterLabels = UIStackView()

    @UsesAutoLayout
    var subscribeFooterLabelsContainer = UIView()

    var termsOfUseButton = UIButton()

    var privacyButton = UIButton()

    weak var delegate: SubscriptionPageActionsProtcol!

    override init(frame: CGRect) {
        super.init(frame: frame);

        setupSubviews()
        setupLayout()
        setupHandlers()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        self.addSubview(pageControl)
        self.addSubview(subscribeButton)
        self.addSubview(subscribeButtonLabel)
        self.addSubview(subscribeFooterLabelsContainer)
        subscribeFooterLabelsContainer.addSubview(subscribeFooterLabels)

        pageControl.currentPage = currentPage
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        pageControl.numberOfPages = NUMBER_OF_PAGES
        pageControl.currentPageIndicatorTintColor = .darkBlue
        pageControl.pageIndicatorTintColor = .darkBlueWithOpacity

        subscribeButton.setTitle(NSLocalizedString("label.subscribe.subscribe", comment: "").uppercased(), for: .normal)
        subscribeButton.titleLabel!.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 14, weight: .medium): UIFont.systemFont(ofSize: 16, weight: .medium)
        subscribeButton.backgroundColor = UIColor.darkBlue
        subscribeButton.setTitleColor(.white, for: .normal)

        subscribeButtonLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 12, weight: .light) : UIFont.systemFont(ofSize: 14, weight: .light)
        subscribeButtonLabel.text = NSLocalizedString("label.subscribe.offer", comment: "")
        subscribeButtonLabel.textColor = .grayLightA1

        let attributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 10, weight: .light) : UIFont.systemFont(ofSize: 12, weight: .light),
            NSAttributedString.Key.foregroundColor : UIColor.grayLightA1,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]

        termsOfUseButton.setAttributedTitle(NSAttributedString(string: NSLocalizedString("label.subscribe.terms.of.use", comment: ""), attributes: attributes), for: .normal)
        termsOfUseButton.backgroundColor = .white

        privacyButton.setAttributedTitle(NSAttributedString(string: NSLocalizedString("label.subscribe.privacy", comment: ""), attributes: attributes), for: .normal)
        privacyButton.backgroundColor = .white


        subscribeFooterLabels.addArrangedSubview(termsOfUseButton)
        subscribeFooterLabels.addArrangedSubview(privacyButton)

        subscribeFooterLabels.axis = .horizontal
        subscribeFooterLabels.distribution = .fillProportionally
        subscribeFooterLabels.spacing = 1

        subscribeFooterLabelsContainer.backgroundColor = .grayLightA1
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: self.topAnchor, constant: UIScreen.main.bounds.height * 0.025),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            subscribeButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5),
            subscribeButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.075),
            subscribeButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: UIScreen.main.bounds.height * 0.025),
            subscribeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            subscribeButtonLabel.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 15),
            subscribeButtonLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            subscribeFooterLabelsContainer.heightAnchor.constraint(equalToConstant: 15),
            subscribeFooterLabelsContainer.widthAnchor.constraint(equalToConstant: 180),
            subscribeFooterLabelsContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            subscribeFooterLabelsContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            subscribeFooterLabels.heightAnchor.constraint(equalToConstant: 15),
            subscribeFooterLabels.widthAnchor.constraint(equalToConstant: 180),
            subscribeFooterLabels.bottomAnchor.constraint(equalTo: subscribeFooterLabelsContainer.bottomAnchor, constant: 0),
            subscribeFooterLabels.centerXAnchor.constraint(equalTo: subscribeFooterLabelsContainer.centerXAnchor)
        ])
    }

    func setupHandlers() {
        pageControl.addTarget(self, action: #selector(onControlTap), for: .allEvents)
        subscribeButton.addTarget(self, action: #selector(onSubscribeTap), for: .touchUpInside)
        termsOfUseButton.addTarget(self, action: #selector(onTermsTap), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(onPrivacyTap), for: .touchUpInside)
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

       NSLayoutConstraint.activate([
           subscribeFooter.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
           subscribeFooter.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.4),
           subscribeFooter.widthAnchor.constraint(equalToConstant: self.view.frame.width)
       ])
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
        subscribeViewModel.restoreSubscription { [weak self] in
            self!.dismiss(animated: true) {
                self!.delegate.modalDismissed()
            }
        }
    }

    func onSubscribeTap() {
        subscribeViewModel.performSubscription { [weak self] in
            self!.dismiss(animated: true) {
                self!.delegate.modalDismissed()
            }
        }
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
