//
//  AppFont.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 22/12/24.
//

import UIKit

class AppFont {
    func setFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SF-Pro-Text-Medium", size: size) ?? .systemFont(ofSize: size)
    }
}
