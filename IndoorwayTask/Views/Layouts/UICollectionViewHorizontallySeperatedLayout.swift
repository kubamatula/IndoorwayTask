//
//  UICollectionViewHorizontallySeperatedLayout.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//
//  Layout adding a horizontal line at the top of each collectionViewCell,
//  but those in the first row

import UIKit

private let separatorDecorationView = "HorizontalSeperator"

class UICollectionViewHorizontallySeperatedLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        register(HorizontalSeperatorView.self, forDecorationViewOfKind: separatorDecorationView)
        minimumLineSpacing = IndoorwayDimensions.seperatorHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        let seperatorHeight = self.minimumLineSpacing
        
        var decorationAttributes: [UICollectionViewLayoutAttributes] = []
        
        //skipping first cell
        for layoutAttribute in layoutAttributes where layoutAttribute.indexPath.item >= 1 {
            let separatorAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: separatorDecorationView,
                                                                      with: layoutAttribute.indexPath)
            let cellFrame = layoutAttribute.frame
            separatorAttribute.frame = CGRect(x: cellFrame.origin.x,
                                              y: cellFrame.origin.y - seperatorHeight,
                                              width: cellFrame.size.width,
                                              height: seperatorHeight)
            separatorAttribute.zIndex = Int.max
            decorationAttributes.append(separatorAttribute)
        }
        
        return layoutAttributes + decorationAttributes
    }
}


