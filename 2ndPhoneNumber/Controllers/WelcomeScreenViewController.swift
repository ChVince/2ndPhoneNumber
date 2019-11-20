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
        ImageDescription(imagePath: "feature1", description: "28+ countries"),
        ImageDescription(imagePath: "feature2", description: "Spam free"),
        ImageDescription(imagePath: "feature3", description: "Multiple phone numbers"),
        ImageDescription(imagePath: "feature4", description: "Chip international calls")
    ])

    var topWelcomeText: UILabel!
    var getStartedButton: UIButton!

    override func loadView() {
        super.loadView()

        topWelcomeText = setupTopWelcomeText()
        getStartedButton = setupGetStartedButton()

        setupFutureList()

        getStartedButton.addTarget(self, action: #selector(self.onGetStaredTounch(sender:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    func setupTopWelcomeText() -> UILabel {
        let topWelcomeText = UILabel()

        let attributedText = NSMutableAttributedString(string: NSLocalizedString("label.start.welcome", comment: ""), attributes:[
            NSAttributedString.Key.font: UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont(name: "Circe-Bold", size: 20)!: UIFont(name: "Circe-Bold", size: 24)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])

        attributedText.append(NSMutableAttributedString(string: "\n\(NSLocalizedString("label.app.name", comment: ""))", attributes:[
            NSAttributedString.Key.font: UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont(name: "Circe-Bold", size: 28)!: UIFont(name: "Circe-Bold", size: 32)!,
            NSAttributedString.Key.foregroundColor: UIColor.darkBlue
        ]))

        topWelcomeText.attributedText = attributedText
        topWelcomeText.translatesAutoresizingMaskIntoConstraints = false
        topWelcomeText.textAlignment = .left
        topWelcomeText.numberOfLines = 2

        self.view.addSubview(topWelcomeText)
        NSLayoutConstraint.activate([
            topWelcomeText.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: view.frame.size.height * 0.1),
            topWelcomeText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            topWelcomeText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
        ])

        return topWelcomeText
    }

    func setupFutureList() {
        let featureList = UIStackView()
        featureList.distribution = .fillProportionally
        featureList.axis = .vertical
        featureList.translatesAutoresizingMaskIntoConstraints = false

        imageDescriptions.forEach({ (item) in
            let view = self.createFeatureListView(imagePath: item.imagePath, description: item.description)
            featureList.addArrangedSubview(view)
        })
        self.view.addSubview(featureList)

        NSLayoutConstraint.activate([
            featureList.topAnchor.constraint(equalTo: topWelcomeText.bottomAnchor, constant: view.frame.size.height * 0.1),
            featureList.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            featureList.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            featureList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.size.height * -0.2)
        ])
    }

    func setupGetStartedButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("label.start.get.started", comment: ""), for: .normal)
        button.titleLabel!.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? UIFont.systemFont(ofSize: 14, weight: .medium): UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.darkBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 20 : 30

        self.view.addSubview(button)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: view.frame.width * 0.6),
            button.heightAnchor.constraint(equalToConstant: view.frame.height * 0.07),
            button.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: view.frame.size.height * -0.05),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        return button
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
        let addNumberNavigationController = AddNumberNavigationController()
        addNumberNavigationController.modalPresentationStyle = .overFullScreen
        present(addNumberNavigationController, animated: true)
    }
}
