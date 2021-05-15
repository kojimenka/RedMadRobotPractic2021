//
//  PostCollectionViewCell.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import UIKit

final class PostCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func nib() -> UINib {
            return UINib(nibName: "PostCollectionViewCell", bundle: nil)
        }

}
