//
//  PhotoItemCell.swift
//  Gallery
//
//  Created by Dmitriy Budanov on 26.04.2022.
//

import UIKit

class GalleryViewCell: UICollectionViewCell {
    
    var img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        self.addSubview(img)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
