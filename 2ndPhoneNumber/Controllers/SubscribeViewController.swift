//
//  File.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

struct SubscriptionPageData {
    var imageName: String
    var imageTitle: String
    var description: String
}

class SubscribeViewHeader: UIView {
    var restoreButton: UIButton!
    var closeButton: UIButton!

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
        closeButton.setImage(UIImage(named: "label.subscribe.close"), for: .normal)

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

    }

    @objc func onCloseButtonTap(sender: UIButton) {

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

    override init(frame: CGRect) {
        super.init(frame: frame);

        setupLayout()
        setupHandlers()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        pageControl = setupPageControl()
        subscribeButton = setupSubscribeButton()
        termsOfUseButton = setupTermsOfUseButton()
        privacyButton = setupPrivacyButton()

        setupSubscribeLabel()
        setupSubcribeBottomLabels()
    }

    func setupHandlers() {
        pageControl.addTarget(self, action: #selector(onControlTap), for: .touchUpInside)
        subscribeButton.addTarget(self, action: #selector(onSubscribeTap), for: .touchUpInside)
        termsOfUseButton.addTarget(self, action: #selector(onTermsTap), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(onPrivacyTap), for: .touchUpInside)
    }

    func setupPageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.currentPage = currentPage
        pageControl.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = NUMBER_OF_PAGES
        pageControl.currentPageIndicatorTintColor = .darkBlue
        pageControl.pageIndicatorTintColor = .darkBlueWithOpacity

        self.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: self.topAnchor),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: 90),
            pageControl.heightAnchor.constraint(equalToConstant: 10)
        ])

        return pageControl
    }

    func setupSubscribeButton() -> UIButton {
        let subscribeButton = UIButton(type: .system)
        subscribeButton.setTitle(NSLocalizedString("label.subscribe.subscribe", comment: ""), for: .normal)
        subscribeButton.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.backgroundColor = UIColor.darkBlue
        subscribeButton.setTitleColor(.white, for: .normal)
        subscribeButton.layer.cornerRadius = 28

        self.addSubview(subscribeButton)
        NSLayoutConstraint.activate([
            subscribeButton.widthAnchor.constraint(equalToConstant: 218),
            subscribeButton.heightAnchor.constraint(equalToConstant: 56),
            subscribeButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 50),
            subscribeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        return subscribeButton
    }

    func setupSubscribeLabel() {
        let subscribeButtonLabel = UILabel()
        subscribeButtonLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        subscribeButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        subscribeButtonLabel.text = NSLocalizedString("label.subscribe.offer", comment: "")
        subscribeButtonLabel.textColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1)

        self.addSubview(subscribeButtonLabel)
        NSLayoutConstraint.activate([
            subscribeButtonLabel.heightAnchor.constraint(equalToConstant: 17),
            subscribeButtonLabel.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 25),
            subscribeButtonLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setupTermsOfUseButton() -> UIButton {
        let termOfUseButton = UIButton()

        let attributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .light),
            NSAttributedString.Key.foregroundColor : UIColor.grayLightA1,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]

        termOfUseButton.setAttributedTitle(NSAttributedString(string: NSLocalizedString("label.subscribe.terms.of.use", comment: ""), attributes: attributes), for: .normal)
        termOfUseButton.backgroundColor = .white

        return termOfUseButton
    }

    func setupPrivacyButton() -> UIButton {
        let privacyButton = UIButton()

        let attributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .light),
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
            subscribeBottomLabelsContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            subscribeBottomLabelsContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func updatePageControlIndicator() {
        pageControl.currentPage = currentPage
    }

    @objc func onControlTap() {
        let collectionView = self.superview as! UICollectionView
        let nextIndex = self.currentPage + 1

        collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
    }

    @objc func onSubscribeTap() {

    }

    @objc func onTermsTap() {
        print("Hello")
    }

    @objc func onPrivacyTap() {
        print("Hello")
    }
}

class SubscribeViewPageCell: UICollectionViewCell {
    var subscriptionPageData: SubscriptionPageData! {
        didSet {
            setupPageData()
        }
    }

    var imageView: UIImageView!
    var imageTitleView: UILabel!
    var imageDescriptionView: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame);

        setupPageLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupPageLayout() {
        imageView = setupImageView()
        imageTitleView = setupImageTitle()
        imageDescriptionView = setupDescription()
    }

    func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 159),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        return imageView
    }

    func setupImageTitle() -> UILabel {
        let imageTitleView = UILabel()
        imageTitleView.translatesAutoresizingMaskIntoConstraints = false
        imageTitleView.font = UIFont(name: "Circe-Bold", size: 33)
        imageTitleView.textColor = .darkBlue
        imageTitleView.textAlignment = .center

        self.addSubview(imageTitleView)

        NSLayoutConstraint.activate([
            imageTitleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageTitleView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        return imageTitleView
    }

    func setupDescription() -> UILabel {
        let imageDescriptionView = UILabel()
        imageDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        imageDescriptionView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        imageDescriptionView.textColor = .black
        imageDescriptionView.textAlignment = .center

        self.addSubview(imageDescriptionView)

        NSLayoutConstraint.activate([
            imageDescriptionView.topAnchor.constraint(equalTo: imageTitleView.bottomAnchor, constant: 12),
            imageDescriptionView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        return imageDescriptionView
    }

    func setupPageData() {
        imageView.image = UIImage(named: subscriptionPageData.imageName)
        imageTitleView.text = subscriptionPageData.imageTitle
        imageDescriptionView.text = subscriptionPageData.description
    }
}

class SubscribeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
     let subscriptionPageDataList = [SubscriptionPageData]([
        SubscriptionPageData(imageName: "realNumber", imageTitle: "Real Number", description: "Contact anyone with your real number"),
        SubscriptionPageData(imageName: "zeroAds", imageTitle: "Zero ads", description: "Enjoy the complete ad-free experience"),
        SubscriptionPageData(imageName: "anonymous", imageTitle: "Completely anonymous", description: "Call and send text securely"),
        SubscriptionPageData(imageName: "internationalAccess", imageTitle: "International access", description: "Text and call country internationally")
    ])

    var subscribeHeader: SubscribeViewHeader!
    var subscribeFooter: SubscribeViewFooter!

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white

        setupCollectionView()
        subscribeHeader = setupViewHeader()
        subscribeFooter = setupViewFooter()
    }

    func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(SubscribeViewPageCell.self, forCellWithReuseIdentifier: String(describing: SubscribeViewPageCell.self))
    }

    func setupViewHeader() -> SubscribeViewHeader {
        let subscribeViewHeader = SubscribeViewHeader()
        subscribeViewHeader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subscribeViewHeader)

        NSLayoutConstraint.activate([
            subscribeViewHeader.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            subscribeViewHeader.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            subscribeViewHeader.heightAnchor.constraint(equalToConstant: 50)
        ])

        return subscribeViewHeader
    }

    func setupViewFooter() -> SubscribeViewFooter {
        let subscribeViewFooter = SubscribeViewFooter()
        subscribeViewFooter.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(subscribeViewFooter)

        NSLayoutConstraint.activate([
            subscribeViewFooter.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            subscribeViewFooter.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            subscribeViewFooter.heightAnchor.constraint(equalToConstant: 236)
        ])

        return subscribeViewFooter
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


}
