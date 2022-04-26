//
//  extension_AuthViewController.swift
//  Gallery
//
//  Created by Dmitriy Budanov on 26.04.2022.
//

import Foundation
import UIKit

extension AuthViewController {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> AuthViewController? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
        ).instantiate(withOwner: nil, options: nil)[0] as? AuthViewController
    }
}
