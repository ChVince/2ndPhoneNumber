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

    init(_ imageName: String, imageTitle: String, description: String) {
        self.imageName = imageName
        self.imageTitle = imageTitle
        self.description = description
    }
}

class SubscribeViewHeader: UIView {
    let buttonsView: UIStackView = {
        let _buttonsView = UIStackView()
        _buttonsView.axis = .horizontal
        _buttonsView.translatesAutoresizingMaskIntoConstraints = false
        _buttonsView.distribution = .equalSpacing
        _buttonsView.alignment = .center
        return _buttonsView
    }()

    let restoreButton: UIButton = {
        let _restoreButton = UIButton()
        _restoreButton.translatesAutoresizingMaskIntoConstraints = false
        _restoreButton.setTitle("Restore", for: .normal)
        _restoreButton.titleLabel!.font = UIFont(name: "SF-Compact-Text-Regular", size: 16)
        _restoreButton.setTitleColor(.black, for: .normal)
        return _restoreButton
    }()

    let closeButton: UIButton = {
        let _closeButton = UIButton()
        _closeButton.translatesAutoresizingMaskIntoConstraints = false
        _closeButton.setImage(UIImage(named: "close"), for: .normal)
        return _closeButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame);
        setupHandlers()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
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

    func setupHandlers() {
        restoreButton.addTarget(self, action: #selector(self.onTouch), for: .touchUpInside)
    }

    @objc func onTouch() {
        print("Hello")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view != self {
            return view
        }
        return nil
    }
}

class SubscribeViewFooter: UIView {
    let pageControl: UIPageControl = {
        let _pageControl = UIPageControl()
        _pageControl.currentPage = 0
        _pageControl.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
        _pageControl.translatesAutoresizingMaskIntoConstraints = false
        _pageControl.numberOfPages = 4 // ???
        _pageControl.currentPageIndicatorTintColor = .blueDark
        _pageControl.pageIndicatorTintColor = .blueDarkWithOpacity
        return _pageControl
    }()

    let subscribeButton: UIButton = {
        var _subscribeButton = UIButton(type: .system)
        _subscribeButton.setTitle("SUBSCRIBE", for: .normal)// ??
        _subscribeButton.titleLabel!.font = UIFont(name: "SFUIText-Medium", size: 16)
        _subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        _subscribeButton.backgroundColor = UIColor.blueDark
        _subscribeButton.setTitleColor(.white, for: .normal)
        _subscribeButton.layer.cornerRadius = 28
        return _subscribeButton
    }()

    let subscribeButtonLabel: UILabel = {
        let _subscribeButtonLabel = UILabel()
        _subscribeButtonLabel.font = UIFont(name: "SFUIText-Light", size: 14)
        _subscribeButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        _subscribeButtonLabel.text = "3 days free, then $7.99/week"
        _subscribeButtonLabel.textColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1)
        return _subscribeButtonLabel
    }()

    let subscribeBottomLabels: UIView = {
        let _termOfUse = UIButton()
        let _privacyPolicy = UIButton()

        let attributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: "SFUIText-Light", size: 12)!,
            NSAttributedString.Key.foregroundColor : UIColor.grayLightA1,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]

        _termOfUse.setAttributedTitle(NSAttributedString(string: "Term of Use", attributes: attributes), for: .normal)
        _termOfUse.backgroundColor = .white
        _privacyPolicy.setAttributedTitle(NSAttributedString(string: "Privacy Policy", attributes: attributes), for: .normal)
        _privacyPolicy.backgroundColor = .white

        let _subscribeBottomLabels = UIStackView(arrangedSubviews: [_termOfUse, _privacyPolicy])
        _subscribeBottomLabels.axis = .horizontal
        _subscribeBottomLabels.distribution = .fillProportionally
        _subscribeBottomLabels.spacing = 1

        _subscribeBottomLabels.translatesAutoresizingMaskIntoConstraints = false

        let _subscribeBottomLabelsContainer = UIView()
        _subscribeBottomLabelsContainer.backgroundColor = .grayLightA1
        _subscribeBottomLabelsContainer.translatesAutoresizingMaskIntoConstraints = false
        _subscribeBottomLabelsContainer.addSubview(_subscribeBottomLabels)

        NSLayoutConstraint.activate([
           _subscribeBottomLabels.heightAnchor.constraint(equalToConstant: 15),
           _subscribeBottomLabels.widthAnchor.constraint(equalToConstant: 180),
           _subscribeBottomLabels.bottomAnchor.constraint(equalTo: _subscribeBottomLabelsContainer.bottomAnchor, constant: 0),
           _subscribeBottomLabels.centerXAnchor.constraint(equalTo: _subscribeBottomLabelsContainer.centerXAnchor)
       ])

        return _subscribeBottomLabelsContainer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame);
        setupLayout()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        setupPageControl()
        setupSubscribeButton()
        setupSubscribeLabel()
        setupSubcribeBottomLabels()
    }

    func setupPageControl() {
        self.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: self.topAnchor),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: 90),
            pageControl.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func setupSubscribeButton() {
        self.addSubview(subscribeButton)
        NSLayoutConstraint.activate([
            subscribeButton.widthAnchor.constraint(equalToConstant: 218),
            subscribeButton.heightAnchor.constraint(equalToConstant: 56),
            subscribeButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 50),
            subscribeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setupSubscribeLabel() {
        self.addSubview(subscribeButtonLabel)
        NSLayoutConstraint.activate([
            subscribeButtonLabel.heightAnchor.constraint(equalToConstant: 17),
            subscribeButtonLabel.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 25),
            subscribeButtonLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setupSubcribeBottomLabels() {
        self.addSubview(subscribeBottomLabels)

        NSLayoutConstraint.activate([
            subscribeBottomLabels.heightAnchor.constraint(equalToConstant: 15),
            subscribeBottomLabels.widthAnchor.constraint(equalToConstant: 180),
            subscribeBottomLabels.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            subscribeBottomLabels.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

}
class SubscribeViewPageCell: UICollectionViewCell {
    var subscriptionPageData: SubscriptionPageData? {
        didSet {
            setupPageLayout()
        }
    }

    var imageView: UIImageView = {
        var _imageView = UIImageView()
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        return _imageView
    }()

    var imageTitleView: UILabel = {
        var _imageTitleView = UILabel()
        _imageTitleView.translatesAutoresizingMaskIntoConstraints = false
        _imageTitleView.font = UIFont(name: "Circe-Bold", size: 33)
        _imageTitleView.textColor = .blueDark
        _imageTitleView.textAlignment = .center
        return _imageTitleView
    }()

    var imageDescriptionView: UILabel = {
        var _imageDescriptionView = UILabel()
        _imageDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        _imageDescriptionView.font = UIFont(name: "SFUIText-Regular", size: 14)
        _imageDescriptionView.textColor = .black
        _imageDescriptionView.textAlignment = .center
        return _imageDescriptionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame);
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupPageLayout() {
        guard let unwrappedSubscriptionPageData = subscriptionPageData else {
            return
        }

        setupImage(imageName: unwrappedSubscriptionPageData.imageName)
        setupTitle(imageTitle: unwrappedSubscriptionPageData.imageTitle)
        setupDescription(imageDescription: unwrappedSubscriptionPageData.description)
    }


    func setupImage(imageName: String) {
        let image = UIImage(named: imageName)
        imageView.image = image

        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 159),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setupTitle(imageTitle: String) {
        imageTitleView.text = imageTitle
        self.addSubview(imageTitleView)

        NSLayoutConstraint.activate([
            imageTitleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageTitleView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setupDescription(imageDescription: String) {
        imageDescriptionView.text = imageDescription
        self.addSubview(imageDescriptionView)

        NSLayoutConstraint.activate([
           imageDescriptionView.topAnchor.constraint(equalTo: imageTitleView.bottomAnchor, constant: 12),
           imageDescriptionView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
       ])
    }
}

class SubscribeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
     let subscriptionPageDataList = [SubscriptionPageData]([
        SubscriptionPageData("realNumber", imageTitle: "Real Number", description: "Contact anyone with your real number"),
        SubscriptionPageData("zeroAds", imageTitle: "Zero ads", description: "Enjoy the complete ad-free experience"),
        SubscriptionPageData("anonymous", imageTitle: "Completely anonymous", description: "Call and send text securely"),
        SubscriptionPageData("internationalAccess", imageTitle: "International access", description: "Text and call country internationally")
    ])

    let subscribeViewHeader: UIView = {
        let _subscribeViewheader = SubscribeViewHeader()
        _subscribeViewheader.translatesAutoresizingMaskIntoConstraints = false
        return _subscribeViewheader
    }()

    let subscribeViewFooter: UIView = {
        let _subscribeViewFooter = SubscribeViewFooter()
        _subscribeViewFooter.translatesAutoresizingMaskIntoConstraints = false
        return _subscribeViewFooter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        collectionView?.register(SubscribeViewPageCell.self, forCellWithReuseIdentifier: "cellId")
        setupCommonLayout()
    }

    func setupCommonLayout() {
        view.addSubview(subscribeViewHeader)
        view.addSubview(subscribeViewFooter)
        NSLayoutConstraint.activate([
            subscribeViewHeader.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            subscribeViewHeader.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            subscribeViewHeader.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            subscribeViewFooter.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            subscribeViewFooter.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            subscribeViewFooter.heightAnchor.constraint(equalToConstant: 236)
        ])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    //MARK: number of pages
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptionPageDataList.count
    }

    //MARK: space between pages
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    //MARK: return cellView (single page)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SubscribeViewPageCell
        cellView.subscriptionPageData = subscriptionPageDataList[indexPath.item]
        return cellView
    }

    //MARK: return size for 'Page' section
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
