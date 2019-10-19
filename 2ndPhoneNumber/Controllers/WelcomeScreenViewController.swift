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

    init(_ imagePath: String, _ description: String) {
        self.imagePath = imagePath
        self.description = description
    }
}

class WelcomeScreenController: UIViewController {
    fileprivate var imageDescriptions = [ImageDescription]([
        ImageDescription("feature1", "28+ countries"),
        ImageDescription("feature2", "Spam free"),
        ImageDescription("feature3", "Multiple phone numbers"),
        ImageDescription("feature4", "Chip international calls")
    ])

    var topWelcomeText: UILabel = {
        var _topWelcomeText = UILabel()

        var attributedText = NSMutableAttributedString(string: "Welcome to", attributes:[
            NSAttributedString.Key.font: UIFont(name: "Circe-Bold", size: 24)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])

        attributedText.append(NSMutableAttributedString(string: "\n2nd Phone Number", attributes:[
            NSAttributedString.Key.font: UIFont(name: "Circe-Bold", size: 33)!,
            NSAttributedString.Key.foregroundColor: UIColor.darkBlue
        ]))

        _topWelcomeText.attributedText = attributedText
        _topWelcomeText.translatesAutoresizingMaskIntoConstraints = false
        _topWelcomeText.textAlignment = .left
        _topWelcomeText.numberOfLines = 2
        return _topWelcomeText
    }()

    var featureList: UIStackView = {
        var _featureList = UIStackView()
        _featureList.distribution = .fillProportionally
        _featureList.axis = .vertical
        _featureList.translatesAutoresizingMaskIntoConstraints = false
        return _featureList
    }()

    var getStartedButton: UIButton = {
        var _button = UIButton(type: .system)
        _button.setTitle("GET STARTED", for: .normal)
        _button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        _button.translatesAutoresizingMaskIntoConstraints = false
        _button.backgroundColor = UIColor.darkBlue
        _button.setTitleColor(UIColor.white, for: .normal)
        _button.layer.cornerRadius = 28
        return _button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTopWelcomeText()
        setupFeatureList()
        setupGetStartedButton()
    }

    private func setupTopWelcomeText() {
        self.view.addSubview(topWelcomeText)
        NSLayoutConstraint.activate([
            topWelcomeText.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: view.frame.size.height * 0.1),
            topWelcomeText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            topWelcomeText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
        ])
    }

    private func setupFeatureList() {
        imageDescriptions.forEach({ (item) in
            let view = self._createFeatureListView(imagePath: item.imagePath, description: item.description)
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

    private func setupGetStartedButton() {
        self.view.addSubview(getStartedButton)

        NSLayoutConstraint.activate([
            getStartedButton.widthAnchor.constraint(equalToConstant: 218),
            getStartedButton.heightAnchor.constraint(equalToConstant: 56),
            getStartedButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: view.frame.size.height * -0.05),
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

         getStartedButton.addTarget(self, action: #selector(self.onGetStaredTounch), for: .touchUpInside)
    }

    private func _createFeatureListView(imagePath: String, description: String) -> UIView {
        let image = UIImage(named: imagePath)
        let imageView = UIImageView(image: image!)
        let imageLabel = UILabel()

        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageLabel.text = description
        imageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        imageLabel.textColor = .black

        let view = UIStackView(arrangedSubviews: [imageView, imageLabel])
        view.distribution = .fill
        view.alignment = .center
        view.setCustomSpacing(23, after: imageView)
        return view
    }

  @objc func onGetStaredTounch() {
        self.navigationController?.pushViewController(CountryListViewController(), animated: true)
    }
}
