//
//  ViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 19/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

fileprivate struct ImageDescription {
    var imagePath: String
    var description: String
}

class WelcomeScreenController: UIViewController {
    fileprivate var imageDescriptions = [ImageDescription]([
        ImageDescription(imagePath: "global", description: NSLocalizedString("label.start.feature.global", comment: "")),
        ImageDescription(imagePath: "antispam", description: NSLocalizedString("label.start.feature.antispam", comment: "")),
        ImageDescription(imagePath: "sims", description: NSLocalizedString("label.start.feature.sims", comment: "")),
        ImageDescription(imagePath: "chip", description: NSLocalizedString("label.start.feature.chip", comment: ""))
    ])

    @UsesAutoLayout
    var topWelcomeText = UILabel()

    @UsesAutoLayout
    var getStartedButton = UIRoundedButton(type: .custom)

    @UsesAutoLayout
    var featureList = UIStackView()

    var delegate: ModalHandler!

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white

        setupViews()
        setupLayout()
        setupHadlers()
    }

    func setupViews() {
        setupTopWelcomeText()
        setupGetStartedButton()
        setupFutureList()
    }

    func setupLayout() {
        topWelcomeText.setAnchors(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: UIEdgeInsets(top: view.frame.size.height * 0.1, left: 30, bottom: 0, right: 30)
        )

        featureList.setAnchors(
            top: topWelcomeText.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: UIEdgeInsets(
                top: view.frame.size.height * 0.1,
                left: 30,
                bottom: 0,
                right: 30
            )
        )

        featureList.setSize(width: 0, height: view.frame.size.height * 0.45)

        getStartedButton.setAnchors(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            padding: UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: view.frame.size.height * 0.05,
                right: 0
            )
        )

        getStartedButton.setSize(width: view.frame.width * 0.6, height: view.frame.height * 0.07)

        getStartedButton.alignXCenter()
    }

    func setupHadlers() {
        getStartedButton.addTarget(self, action: #selector(self.onGetStaredTounch(sender:)), for: .touchUpInside)
    }

    func setupTopWelcomeText() {
        let attributedText = NSMutableAttributedString(string: NSLocalizedString("label.start.welcome", comment: ""), attributes:[
            NSAttributedString.Key.font: UIDevice.current.screenType == .iPhones_5_5s_5c_SE ?
                UIFont(name: "Circe-Bold", size: 20)!:
                UIFont(name: "Circe-Bold", size: 24)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])

        attributedText.append(NSMutableAttributedString(string: "\n\(NSLocalizedString("label.app.name", comment: ""))", attributes:[
            NSAttributedString.Key.font: UIDevice.current.screenType == .iPhones_5_5s_5c_SE ?
                UIFont(name: "Circe-Bold", size: 28)!:
                UIFont(name: "Circe-Bold", size: 32)!,
            NSAttributedString.Key.foregroundColor: UIColor.darkBlue
        ]))

        topWelcomeText.attributedText = attributedText
        topWelcomeText.textAlignment = .left
        topWelcomeText.numberOfLines = 2

        self.view.addSubview(topWelcomeText)

    }

    func setupFutureList() {
        featureList.distribution = .fillProportionally
        featureList.axis = .vertical

        imageDescriptions.forEach({ (item) in
            let view = self.createFeatureListView(imagePath: item.imagePath, description: item.description)
            featureList.addArrangedSubview(view)
        })
        self.view.addSubview(featureList)
    }

    func setupGetStartedButton() {
        getStartedButton.setTitle(NSLocalizedString("label.start.get.started", comment: "").uppercased(), for: .normal)
        getStartedButton.backgroundColor = UIColor.darkBlue
        getStartedButton.titleLabel!.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 14, weight: .medium): UIFont.systemFont(ofSize: 16, weight: .medium)
        getStartedButton.backgroundColor = UIColor.darkBlue
        getStartedButton.setTitleColor(UIColor.white, for: .normal)

        self.view.addSubview(getStartedButton)
    }

    private func createFeatureListView(imagePath: String, description: String) -> UIView {
        let image = UIImage(named: imagePath)
        let imageView = UIImageView(image: image!)
        let imageLabel = UILabel()

        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageLabel.text = description
        imageLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 14, weight: .medium): UIFont.systemFont(ofSize: 16, weight: .medium)
        imageLabel.textColor = .black

        let view = UIStackView(arrangedSubviews: [imageView, imageLabel])
        view.distribution = .fill
        view.alignment = .center
        view.setCustomSpacing(23, after: imageView)
        return view
    }

    @objc func onGetStaredTounch(sender: UIButton) {
        self.dismiss(animated: false) {
            self.delegate.modalDismissed()
        }
    }
}
