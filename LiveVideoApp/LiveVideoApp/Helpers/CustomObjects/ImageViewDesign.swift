//
//  ImageViewDesign.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 22/12/24.
//

import UIKit

@IBDesignable
class ImageViewDesign: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
