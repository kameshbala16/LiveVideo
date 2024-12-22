//
//  TextFieldDesign.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 22/12/24.
//

import UIKit

@IBDesignable
class TextFieldDesign: UITextField {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateViews()
        }
    }
    @IBInspectable var placeholderColor: UIColor = .white {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0.0 {
        didSet {
            updateViews()
        }
    }
    @IBInspectable var rightButtonImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        layer.cornerRadius = cornerRadius
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
        clipsToBounds = true
        
        guard let image = rightButtonImage else { return }
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        button.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        button.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        containerView.addSubview(button)
        
        rightView = containerView
        rightViewMode = .always
    }
    @objc private func rightButtonTapped() {
        print("Emoji button tapped")
        // You can add custom actions here
    }
}
