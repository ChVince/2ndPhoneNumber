//
//  EditContactViewController.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 28.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class UILineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .systemGray
        self.translatesAutoresizingMaskIntoConstraints = false
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}

class UIContactTextFiled : UITextField {

    let padding = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    var fieldKey: ContactFieldKey!

    @UsesAutoLayout
    var borderBottom = UILineView()
    var showBottomBorder = true {
        didSet {
            if showBottomBorder {
                borderBottom.isHidden = false
            } else {
                borderBottom.isHidden = true
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 14) : .systemFont(ofSize: 16)
        self.borderStyle = .none

        addSubview(borderBottom)

        borderBottom.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            borderBottom.topAnchor.constraint(equalTo: self.bottomAnchor),
            borderBottom.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            borderBottom.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            borderBottom.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class EditContactViewController: UIViewController {
    var contactViewModel: ContactViewModel! {
        didSet {
            updateSubviewsData()
        }
    }

    @UsesAutoLayout
    var scrollView = UIScrollView()

    @UsesAutoLayout
    var nameTextField = UIContactTextFiled()

    @UsesAutoLayout
    var surnameTextField = UIContactTextFiled()

    @UsesAutoLayout
    var imageView = UICircleImageView()

    @UsesAutoLayout
    var changeImageButtom = UIButton(type: .system)

    @UsesAutoLayout
    var numberTextField = UIContactTextFiled()

    @UsesAutoLayout
    var contactImageContainer = UIView()

    @UsesAutoLayout
    var contactFiledsContainer = UIView()

    @UsesAutoLayout
    var contactFiledsContainerBorderBottom = UILineView()

    @UsesAutoLayout
    var contactFiledsContainerBorderTop = UILineView()

    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.init(red: 235/255, green: 240/255, blue: 245/255, alpha: 1)
        setupNavigationItem()
        setupSubviews()
        setupLayout()

        setupHandlers()
    }

    func setupNavigationItem() {
        self.navigationItem.title = NSLocalizedString("label.account.contact.title", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("label.done", comment: ""), style: .done, target: self, action: #selector(saveChanges))

        self.navigationController?.navigationBar.isTranslucent = false
    }

    func setupSubviews() {
        view.addSubview(scrollView)

        scrollView.addSubview(contactImageContainer)
        scrollView.addSubview(contactFiledsContainer)

        contactFiledsContainer.addSubview(nameTextField)
        contactFiledsContainer.addSubview(surnameTextField)
        contactFiledsContainer.addSubview(numberTextField)
        contactFiledsContainer.addSubview(contactFiledsContainerBorderTop)
        contactFiledsContainer.addSubview(contactFiledsContainerBorderBottom)

        contactImageContainer.addSubview(imageView)
        contactImageContainer.addSubview(changeImageButtom)

        changeImageButtom.setTitleColor(.systemBlue, for: .normal)
        changeImageButtom.titleLabel?.font = .systemFont(ofSize: 16)

        contactImageContainer.backgroundColor = .white
        contactFiledsContainer.backgroundColor = .white

        numberTextField.showBottomBorder = false

        nameTextField.delegate = self
        nameTextField.fieldKey = .NAME

        surnameTextField.delegate = self
        surnameTextField.fieldKey = .SURNAME

        numberTextField.delegate = self
        numberTextField.fieldKey = .NUMBER
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            contactImageContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contactImageContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            contactImageContainer.bottomAnchor.constraint(equalTo: changeImageButtom.bottomAnchor, constant: 10),
        ])

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contactImageContainer.topAnchor, constant: 15),
            imageView.centerXAnchor.constraint(equalTo: contactImageContainer.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            changeImageButtom.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            changeImageButtom.centerXAnchor.constraint(equalTo: contactImageContainer.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            contactFiledsContainer.topAnchor.constraint(equalTo: contactImageContainer.bottomAnchor),
            contactFiledsContainer.widthAnchor.constraint(equalTo: contactImageContainer.widthAnchor),
            contactFiledsContainer.bottomAnchor.constraint(equalTo: numberTextField.bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: contactImageContainer.bottomAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            surnameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            surnameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            numberTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor),
            numberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            numberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            contactFiledsContainerBorderTop.bottomAnchor.constraint(equalTo: contactFiledsContainer.topAnchor),
            contactFiledsContainerBorderTop.widthAnchor.constraint(equalTo: contactFiledsContainer.widthAnchor),
            contactFiledsContainerBorderTop.heightAnchor.constraint(equalToConstant: 0.5),
        ])

        NSLayoutConstraint.activate([
            contactFiledsContainerBorderBottom.bottomAnchor.constraint(equalTo: contactFiledsContainer.bottomAnchor),
            contactFiledsContainerBorderBottom.widthAnchor.constraint(equalTo: contactFiledsContainer.widthAnchor),
            contactFiledsContainerBorderBottom.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }

    func setupHandlers() {
        changeImageButtom.addTarget(self, action: #selector(onChangeImageTap(sender:)), for: .touchUpInside)
    }

    func updateSubviewsData() {
        if let imageName = contactViewModel.contact.image {
            imageView.image = UIImage(named: imageName)
            changeImageButtom.setTitle(NSLocalizedString("label.contact.edit", comment: ""), for: .normal)
        } else {
            imageView.image = UIImage(named: "contact-default")
            changeImageButtom.setTitle(NSLocalizedString("label.contact.add.photo", comment: ""), for: .normal)
        }

        if let name = contactViewModel.contact.name {
            nameTextField.text = name
        } else {
            nameTextField.text = nil
            nameTextField.placeholder = NSLocalizedString("label.contact.name", comment: "")
        }

        if let surname = contactViewModel.contact.surname {
            surnameTextField.text = surname
        } else {
            surnameTextField.text = nil
            surnameTextField.placeholder = NSLocalizedString("label.contact.surname", comment: "")
        }

        if let number = contactViewModel.contact.number {
            numberTextField.text = number
        } else {
            numberTextField.text = nil
            numberTextField.placeholder = NSLocalizedString("label.contact.phone", comment: "")
        }
    }

    @objc func onChangeImageTap(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
        imagePicker.allowsEditing = false

        self.present(imagePicker, animated: true, completion: nil)
    }

    @objc func saveChanges() {
        navigationController?.popViewController(animated: true)
    }
}


extension EditContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

}


extension EditContactViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textFieldView: UITextField) -> Bool {
        guard let contactTextField = textFieldView as? UIContactTextFiled else {
            return true
        }

        let nextFieldKeyIdx = contactTextField.fieldKey.index! + 1
        let value = contactTextField.text!

        contactViewModel.setContactField (
            fieldKey: contactTextField.fieldKey,
            value: value
        )

        switch nextFieldKeyIdx {
        case nameTextField.fieldKey.index:
            nameTextField.becomeFirstResponder()
            break
        case surnameTextField.fieldKey.index:
            surnameTextField.becomeFirstResponder()
            break
        case numberTextField.fieldKey.index:
            numberTextField.becomeFirstResponder()
            break
        default:
            contactTextField.resignFirstResponder()
        }

        return true
    }
}

