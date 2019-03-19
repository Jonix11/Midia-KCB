//
//  UIImageView+Networking.swift
//  Midia
//
//  Created by Jon Gonzalez on 05/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImage(fromURL url: URL) {
        DispatchQueue.global().async { [weak self] in
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
