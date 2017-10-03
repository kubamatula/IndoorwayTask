//
//  HorizontalSeperatorView.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 17/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import Foundation
import UIKit

class HorizontalSeperatorView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = IndoorwayColors.seperatorColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.frame = layoutAttributes.frame
    }
}
