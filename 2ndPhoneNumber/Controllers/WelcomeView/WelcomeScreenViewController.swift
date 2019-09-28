//
//  ViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 19/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var topWelcomeText: UILabel = {
        var _topWelcomeText = UILabel()

        var attributedText = NSMutableAttributedString(string: "Welcome to", attributes:[
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])

        attributedText.append(NSMutableAttributedString(string: "\n2nd Phone Number", attributes:[
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 33),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]))

        _topWelcomeText.attributedText = attributedText
        _topWelcomeText.translatesAutoresizingMaskIntoConstraints = false
        _topWelcomeText.textAlignment = .left
        _topWelcomeText.backgroundColor = .yellow
        _topWelcomeText.numberOfLines = 2
        return _topWelcomeText
    }()

    var featureList: UIStackView = {
        var feature1 = UIView()
        feature1.backgroundColor = .gray

        var feature2 = UIView()
        feature2.backgroundColor = .blue

        var feature3 = UIView()
        feature3.backgroundColor = .red

        var feature4 = UIView()
        feature4.backgroundColor = .green

        var _featureList = UIStackView(arrangedSubviews: [feature1, feature2, feature3, feature4])
        _featureList.distribution = .fillEqually
        _featureList.axis = .vertical
        _featureList.translatesAutoresizingMaskIntoConstraints = false
        return _featureList
    }()

    var getStartedButton: UIButton = {
        var _button = UIButton(type: .system)
        _button.setTitle("GET STARTED", for: .normal)
        _button.translatesAutoresizingMaskIntoConstraints = false
        _button.backgroundColor = UIColor.blue
        _button.setTitleColor(UIColor.white, for: .normal)
        _button.layer.cornerRadius = 28
        return _button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTopWelcomeText()
        setupGetStartedButton()
        setupFeatureList()
    }

    private func setupTopWelcomeText() {
        self.view.addSubview(topWelcomeText)
        NSLayoutConstraint.activate([
            topWelcomeText.topAnchor.constraint(equalTo: view.topAnchor, constant: 121),
            topWelcomeText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            topWelcomeText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            topWelcomeText.heightAnchor.constraint(equalToConstant: 76),
            topWelcomeText.widthAnchor.constraint(greaterThanOrEqualToConstant: 135)
        ])
    }

    private func setupFeatureList() {
        self.view.addSubview(featureList)

        NSLayoutConstraint.activate([
            featureList.topAnchor.constraint(equalTo: topWelcomeText.bottomAnchor, constant: 100),
            featureList.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            featureList.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            featureList.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: -50)
        ])
    }

    private func setupGetStartedButton() {
        self.view.addSubview(getStartedButton)

        NSLayoutConstraint.activate([
            getStartedButton.widthAnchor.constraint(equalToConstant: 218),
            getStartedButton.heightAnchor.constraint(equalToConstant: 56),
            getStartedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    private func _createfeature(imageName: String, description: String) {
        var _featureView = UIView()
        var _featureImage = UIImageView()
    }
}

extension UIButton // reaearch gradients
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
