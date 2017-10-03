//
//  PhotoCollectionViewController.swift
//  IndoorwayTask
//
//  Created by Jakub Matuła on 16/09/2017.
//  Copyright © 2017 Jakub Matuła. All rights reserved.
//

import UIKit

class PhotoCollectionViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    
    private var photoDataSource: PhotoCollectionViewDataSource?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        photoDataSource = PhotoCollectionViewDataSource(collectionView: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = photoDataSource
        collectionView.collectionViewLayout = UICollectionViewHorizontallySeperatedLayout()
    }
    
    // MARK: - UIInteraction
    @IBAction func resetCollection(_ sender: UIButton) {
        photoDataSource?.clear()
    }
    
    @IBAction func addNextPhoto(_ sender: UIButton) {
        photoDataSource?.addNextPhoto()
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: IndoorwayDimensions.thumbnailCellHeight)
    }
}
