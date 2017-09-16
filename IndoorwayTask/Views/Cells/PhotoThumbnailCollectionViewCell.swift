//
//  PhotoThumbnailCollectionViewCell.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

class PhotoThumbnailCollectionViewCell: UICollectionViewCell {
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
//    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue}
    }
    
    var photo: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
        photo = nil
    }
}
