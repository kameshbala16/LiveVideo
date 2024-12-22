//
//  ButtonDesign.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import UIKit

@IBDesignable
class ButtonDesign: UIButton {
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
