//
//  UICollectionViewExtension.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/26/19.
//

import Foundation
import UIKit

extension UICollectionView {
    /// Returns a reusable cell object located by its identifier and also serves to avoid the use of casting class.
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cannot dequeue a cell with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
}

