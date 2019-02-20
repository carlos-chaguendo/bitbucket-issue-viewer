//
//  IssueAttachmentTableViewCell.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 2/20/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit
import struct Core.Logger

class IssueAttachmentTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerNibWithClass(CircleImageCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithClass2(CircleImageCollectionViewCell.self, forIndexPath: indexPath) else {
            preconditionFailure()
        }
        
        if cell.imageView == nil {
            Logger.error("No se cargo imagen view")
        }
        
        
        cell.imageView.image = images[safe: indexPath.row]
        return cell
    }

}
