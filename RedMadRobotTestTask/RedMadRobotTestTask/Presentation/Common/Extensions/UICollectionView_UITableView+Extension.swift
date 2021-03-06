//
//  UICollectionView_UITableView+Extension.swift
//  Highlights
//
//  Created by Дмитрий Марченков on 09.04.2021.
//

import UIKit

extension UIView {
    // Return class name for use it in Register cells
    static var identifier: String {
        return String(describing: self)
    }
}

// CollectionView Extensions
extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    // swiftlint:disable line_length
    func register<T: UICollectionReusableView>(header: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
    }
    
    func register<T: UICollectionReusableView>(footer: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.identifier)
    }
    
    // swiftlint:disable force_cast
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func dequeueHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                withReuseIdentifier: T.identifier,
                                                for: indexPath) as! T
    }

}

extension UICollectionViewCell {
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}

extension UITableViewCell {
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
 
// TableView Extensions
extension UITableView {
    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(header: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func dequeueHeader<T: UITableViewHeaderFooterView>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
    }
}
