//
//  ImageLoader.swift
//  ZEEN
//
//  Created by Ayele  Aryee on 7/4/25.
//

import Foundation


import UIKit
//Function to load the image
extension UIImageView {
    
    func load(url: URL) {
        
        DispatchQueue.global().async {
            
            if let data = try? Data(contentsOf: url),
               
               let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    self.image = image
                }
                
            }
        }
    }
}

