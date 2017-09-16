//
//  UICollectionViewHorizontallySeperatedLayout.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

private let separatorDecorationView = "separator"

class UICollectionViewHorizontallySeperatedLayout: UICollectionViewFlowLayout {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        register(HorizontalSeperatorView.self, forDecorationViewOfKind: separatorDecorationView)
        minimumLineSpacing = 2
    }
    
//    override init() {
//        super.init()
//        register(HorizontalSeperatorView.self, forDecorationViewOfKind: separatorDecorationView)
//        minimumLineSpacing = 2
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        let lineWidth = self.minimumLineSpacing
        
        var decorationAttributes: [UICollectionViewLayoutAttributes] = []
        
        // skip first cell
        for layoutAttribute in layoutAttributes where layoutAttribute.indexPath.item > 0 {
            let separatorAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: separatorDecorationView,                                                                      with: layoutAttribute.indexPath)
            let cellFrame = layoutAttribute.frame
            separatorAttribute.frame = CGRect(x: cellFrame.origin.x,
                                              y: cellFrame.origin.y - lineWidth,
                                              width: cellFrame.size.width,
                                              height: lineWidth)
            separatorAttribute.zIndex = Int.max
            decorationAttributes.append(separatorAttribute)
        }
        
        return layoutAttributes + decorationAttributes
    }
}

class HorizontalSeperatorView: UICollectionReusableView {
    
    var color: UIColor
    
    override init(frame: CGRect) {
        color = .black
        super.init(frame: frame)
        self.backgroundColor = color
    }
    
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        self.color = color
        self.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.frame = layoutAttributes.frame
    }
}


