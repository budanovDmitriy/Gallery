//
//  AuthViewController.swift
//  Gallery
//
//  Created by Dmitriy Budanov on 25.04.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Override methods

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldDidChange(textField)
    }
    
    // MARK: - Private methods

    private func presentGalleryViewController() {
        DispatchQueue.main.async {
            let navigationController = UINavigationController()
            navigationController.setViewControllers([GalleryViewController()], animated: false)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    // MARK: - IBActions

    @IBAction func authAction(_ sender: Any) {
        if  textField.text?.count == 5 && textField.text == "Skipp" {
        presentGalleryViewController()
    }
        else {
            self.popupAlert(title: "Wrong password", message: "Try one more time", actionTitles: ["OK"], actions:[{action1 in
                self.textField.text = ""
            }, nil])
        }
    }
    
    // MARK: - objcActions

    @objc func textFieldDidChange(_ textField: UITextField) {
        if  textField.text?.count == 5 && textField.text == "Skipp" {
            presentGalleryViewController()
        }
    }
}
