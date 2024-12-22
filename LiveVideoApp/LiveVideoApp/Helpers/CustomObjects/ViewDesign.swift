//
//  ViewDesign.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import UIKit

@IBDesignable
class ViewDesign: UIView {
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

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        configureGradient(colors: [.black.withAlphaComponent(0), .black.withAlphaComponent(0.3)])
        layer.addSublayer(gradientLayer)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func configureGradient(colors: [UIColor]) {
        gradientLayer.colors = colors.map { $0.cgColor }
    }
}
