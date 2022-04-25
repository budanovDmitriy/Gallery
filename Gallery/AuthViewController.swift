//
//  AuthViewController.swift
//  Gallery
//
//  Created by Dmitriy Budanov on 25.04.2022.
//

import UIKit

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func presentController() {
        let vc = AuthViewController(nibName: "AuthViewController", bundle: nil)
        self.present(vc,animated: true)
    }
    
    @IBAction func authAction(_ sender: Any) {
        print("yes")
        DispatchQueue.main.async {
            let navigationController = UINavigationController()
            navigationController.setViewControllers([GalleryViewController()], animated: false)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
