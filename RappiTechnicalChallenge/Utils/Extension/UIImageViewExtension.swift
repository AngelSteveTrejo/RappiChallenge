//
//  UIImageViewExtension.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/26/19.
//

import Foundation
import UIKit

extension UIImageView {
    /// Download the image of a url
    ///
    /// - Parameter url: URL
    func loadImage(url: URL)  {
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
