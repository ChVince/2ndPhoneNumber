//
//  AddressViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

fileprivate class UIAddressTextFieldView: UIView {
    var idx: Int?

    var textFieldLabel: UILabel = {
        let _textFieldLabel = UILabel()
        _textFieldLabel.textColor = .gray
        _textFieldLabel.font = UIFont.systemFont(ofSize: 12)
        _textFieldLabel.translatesAutoresizingMaskIntoConstraints = false

        return _textFieldLabel
    }()

    let textFieldView: UITextField = {
        let _textFieldView = UITextField()
        _textFieldView.textColor = .black
        _textFieldView.font = UIFont.systemFont(ofSize: 14)
        _textFieldView.borderStyle = .none
        _textFieldView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            _textFieldView.heightAnchor.constraint(equalToConstant: 15)
        ])

        return _textFieldView
    }()

    let textFieldUnderline: UIView = {
        let _textFieldUnderline = UIView()
        _textFieldUnderline.backgroundColor = .lightGrayF2
        _textFieldUnderline.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            _textFieldUnderline.heightAnchor.constraint(equalToConstant: 1)
        ])
        return _textFieldUnderline
    }()

    override init(frame: CGRect) {
        super.init(frame: frame);
        self.translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        setupLabel()
        setupTextField()
        setupTextFieldUnderline()
    }

    func setupLabel() {
        self.addSubview(textFieldLabel)

        NSLayoutConstraint.activate([
            textFieldLabel.heightAnchor.constraint(equalToConstant: 15),
            textFieldLabel.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

    func setupTextField() {
        self.addSubview(textFieldView)

        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: self.textFieldLabel.bottomAnchor, constant: 5),
            textFieldView.heightAnchor.constraint(equalToConstant: 15),
            textFieldView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

    func setupTextFieldUnderline() {
        self.addSubview(textFieldUnderline)

        NSLayoutConstraint.activate([
            textFieldUnderline.topAnchor.constraint(equalTo: self.textFieldView.bottomAnchor, constant: 10),
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1),
            textFieldUnderline.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}

class AddressViewController: UIViewController {
    let addressViewModel = AddressViewModel()

    let topTextLabel: UILabel = {
        let _topTextLabel = UILabel()
        _topTextLabel.font = UIFont.systemFont(ofSize: 14)
        _topTextLabel.textColor = .lightGray
        _topTextLabel.textAlignment = .left
        _topTextLabel.text = NSLocalizedString("label.address.top", comment: "")
        _topTextLabel.translatesAutoresizingMaskIntoConstraints = false

        _topTextLabel.numberOfLines = 0
        _topTextLabel.lineBreakMode = .byWordWrapping
        return _topTextLabel
    }()

    let textFieldsView: UIStackView = {
        let _textFieldsView = UIStackView()
        _textFieldsView.axis = .vertical
        _textFieldsView.spacing = 15
        _textFieldsView.distribution = .fillEqually
        _textFieldsView.translatesAutoresizingMaskIntoConstraints = false
        return _textFieldsView
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)// MISTIKA
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("label.done", comment: ""), style: .plain, target: self, action: #selector(setupNumber))
        setupListeners()
        setupLayout()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setupListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setupLayout() {
        setupContainerView()
        setupTopText()
        setupFields()
    }

    func setupContainerView() {
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    func setupTopText() {
        scrollView.addSubview(topTextLabel)

        NSLayoutConstraint.activate([
            self.topTextLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
            self.topTextLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            self.topTextLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }

    func setupFields() {
        for (idx, fieldLabel) in addressViewModel.fieldLabelList.enumerated() {
            let addressTextFieldView = UIAddressTextFieldView()
            let textFieldLabel = addressTextFieldView.textFieldLabel
            let textFieldView = addressTextFieldView.textFieldView
            addressTextFieldView.idx = idx
            textFieldLabel.text = fieldLabel
            textFieldView.delegate = self

            self.textFieldsView.addArrangedSubview(addressTextFieldView)
        }

        scrollView.addSubview(textFieldsView)

        NSLayoutConstraint.activate([
            self.textFieldsView.topAnchor.constraint(equalTo: topTextLabel.bottomAnchor, constant: 25),
            self.textFieldsView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            self.textFieldsView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            self.textFieldsView.heightAnchor.constraint(equalToConstant: 320),

            self.textFieldsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    @objc func setupNumber() {

    }

    @objc func keyboardWillShow(notification: NSNotification) {

      let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 10 // scroll to underline
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

extension AddressViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let addressTextFieldView = textField.superview as? UIAddressTextFieldView {
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    addressTextFieldView.textFieldUnderline.backgroundColor = .darkBlue
                }
            )
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let addressTextFieldView = textField.superview as? UIAddressTextFieldView {
            addressTextFieldView.textFieldUnderline.backgroundColor = .lightGrayF2
        }
    }

    func textFieldShouldReturn(_ textFieldView: UITextField) -> Bool {
        guard let addressTextFieldView = textFieldView.superview as? UIAddressTextFieldView else {
            return true
        }

        let nextIdx = addressTextFieldView.idx! + 1
        let value = textFieldView.text!
        
        addressViewModel.setAddressField (
            fieldIdx: addressTextFieldView.idx!,
            value: value
        )

        if nextIdx < addressViewModel.fieldLabelList.count {
            let nextAddressTextFieldView = textFieldsView.arrangedSubviews[nextIdx] as! UIAddressTextFieldView
            nextAddressTextFieldView.textFieldView.becomeFirstResponder()
        }

        textFieldView.resignFirstResponder()
        print(addressViewModel.address)

        return true
    }
}
