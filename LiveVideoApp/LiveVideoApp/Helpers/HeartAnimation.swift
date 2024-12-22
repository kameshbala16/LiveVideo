//
//  HeartAnimation.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 22/12/24.
//

import UIKit

func animateHearts(on superview: UIView) {
    let numberOfHearts = 20
    let alwaysOpaqueHearts = Int.random(in: 5...10)
    let animationDuration: TimeInterval = 5.0

    for index in 0..<numberOfHearts {
        let heartSize = CGFloat.random(in: 20...50)
        
        // Create a heart image
        let heartImageView = UIImageView(image: UIImage(named: "heart-red"))
        heartImageView.frame = CGRect(x: 0, y: 0, width: heartSize, height: heartSize)
        heartImageView.contentMode = .scaleAspectFit
        
        let randomXStart = CGFloat.random(in: superview.bounds.width - 150...superview.bounds.width - 50)
        let randomYStart = CGFloat.random(in: superview.bounds.height - 150...superview.bounds.height - 80)
        heartImageView.frame.origin = CGPoint(x: randomXStart, y: randomYStart)
        
        // Set alpha: 2-3 hearts always have alpha = 1.0
        if index < alwaysOpaqueHearts {
            heartImageView.alpha = 1.0
        } else {
            heartImageView.alpha = CGFloat.random(in: 0.5...1.0)
        }
        
        superview.addSubview(heartImageView)
        
        // Define random animation values
        let randomXOffset = CGFloat.random(in: -150...150) // Spread the hearts horizontally
        let randomScale = CGFloat.random(in: 0.8...1.3) // Random size scaling during animation
        let randomRotation = CGFloat.random(in: -CGFloat.pi/4...CGFloat.pi/4) // Random rotation

        // Create the animation
        UIView.animateKeyframes(withDuration: animationDuration, delay: TimeInterval.random(in: 0...1.0), options: [], animations: {
            // Move the heart upwards and sideways
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                heartImageView.transform = CGAffineTransform(translationX: randomXOffset, y: -superview.bounds.height / 2)
                    .scaledBy(x: randomScale, y: randomScale)
                    .rotated(by: randomRotation)
                heartImageView.alpha = 0.0 // Fade out
            }
        }, completion: { _ in
            // Remove the heart image view after the animation
            heartImageView.removeFromSuperview()
        })
    }
}
