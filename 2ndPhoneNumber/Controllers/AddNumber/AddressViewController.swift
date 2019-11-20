//
//  AddressViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 29/09/2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

fileprivate class UIAddressTextFieldView: UIView {
    var idx: Int!

    var textFieldLabel: UILabel!
    var textFieldView: UITextField!
    var textFieldUnderline: UIView!

    func setupTextFieldLabel() -> UILabel {
        let textFieldLabel = UILabel()
        textFieldLabel.textColor = .gray
        textFieldLabel.font = UIFont.systemFont(ofSize: 12)
        textFieldLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(textFieldLabel)
        NSLayoutConstraint.activate([
            textFieldLabel.heightAnchor.constraint(equalToConstant: 15),
            textFieldLabel.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])

        return textFieldLabel
    }

    func setupTextFieldView() -> UITextField {
        let textFieldView = UITextField()
        textFieldView.textColor = .black
        textFieldView.font = UIFont.systemFont(ofSize: 14)
        textFieldView.borderStyle = .none
        textFieldView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(textFieldView)

        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: self.textFieldLabel.bottomAnchor, constant: 5),
            textFieldView.heightAnchor.constraint(equalToConstant: 15),
            textFieldView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])

        return textFieldView
    }

    func setupTextFieldUnderline() -> UIView {
        let textFieldUnderline = UIView()
        textFieldUnderline.backgroundColor = .lightGrayF2
        textFieldUnderline.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1)
        ])

        self.addSubview(textFieldUnderline)

        NSLayoutConstraint.activate([
            textFieldUnderline.topAnchor.constraint(equalTo: self.textFieldView.bottomAnchor, constant: 10),
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1),
            textFieldUnderline.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])

        return textFieldUnderline
    }

    override init(frame: CGRect) {
        super.init(frame: frame);
        self.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        textFieldLabel = setupTextFieldLabel()
        textFieldView = setupTextFieldView()
        textFieldUnderline = setupTextFieldUnderline()
    }
}

class AddressViewController: UIViewController {
    let addressViewModel = AddressViewModel()

    var topTextLabel: UILabel!
    var textFieldsView: UIStackView!
    var scrollView: UIScrollView!

    func setupTopTextLabel() -> UILabel {
        let topTextLabel = UILabel()
        topTextLabel.font = UIFont.systemFont(ofSize: 14)
        topTextLabel.textColor = .lightGray
        topTextLabel.textAlignment = .left
        topTextLabel.text = NSLocalizedString("label.address.top", comment: "")
        topTextLabel.translatesAutoresizingMaskIntoConstraints = false

        topTextLabel.numberOfLines = 0
        topTextLabel.lineBreakMode = .byWordWrapping

        scrollView.addSubview(topTextLabel)

        NSLayoutConstraint.activate([
            topTextLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
            topTextLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            topTextLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])

        return topTextLabel
    }
    func setupTextFieldsView() -> UIStackView {
        let textFieldsView = UIStackView()
        textFieldsView.axis = .vertical
        textFieldsView.spacing = 15
        textFieldsView.distribution = .fillEqually
        textFieldsView.translatesAutoresizingMaskIntoConstraints = false

        for (idx, fieldLabel) in addressViewModel.fieldLabelList.enumerated() {
            let addressTextFieldView = UIAddressTextFieldView()
            let textFieldLabel = addressTextFieldView.textFieldLabel
            let textFieldView = addressTextFieldView.textFieldView
            addressTextFieldView.idx = idx
            textFieldLabel!.text = fieldLabel
            textFieldView!.delegate = self

            textFieldsView.addArrangedSubview(addressTextFieldView)
        }

        scrollView.addSubview(textFieldsView)

        NSLayoutConstraint.activate([
            textFieldsView.topAnchor.constraint(equalTo: topTextLabel.bottomAnchor, constant: 25),
            textFieldsView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            textFieldsView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            textFieldsView.heightAnchor.constraint(equalToConstant: 320),

            textFieldsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        return textFieldsView
    }
    func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return scrollView
    }
    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("label.done", comment: ""), style: .done, target: self, action: #selector(setupNumber))
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white

        setupLayout()
        setupListeners()
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
        scrollView = setupScrollView()
        topTextLabel = setupTopTextLabel()
        textFieldsView = setupTextFieldsView()

        setupNavigationItem()
    }

    @objc func setupNumber() {

    }

    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
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
