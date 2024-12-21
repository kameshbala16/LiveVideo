//
//  AlertView.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import UIKit

final class AlertView {
    static let shared = AlertView()
    
    private init() {}
    
    func showActionSheet(on viewController: UIViewController, isSuccess: Bool, message: String) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create Custom Title View
        let customView = createHorizontalTitleView(with: isSuccess, message: message)
        alertController.view.addSubview(customView)
        
        // Add Constraints for Custom View
        customView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
            customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 16),
            customView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 16),
            customView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -16),
            customView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // dummy Action
        alertController.addAction(UIAlertAction(title: "", style: .cancel, handler: nil))
        
        viewController.present(alertController, animated: true) {
            // Auto-dismiss after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func createHorizontalTitleView(with isSuccess: Bool, message: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        
        // Icon ImageView
        let iconImageView = UIImageView(image: UIImage(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill"))
        iconImageView.tintColor = isSuccess ? .systemGreen : .systemRed
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Message Label
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .left
        messageLabel.numberOfLines = 1
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconImageView)
        container.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
}
