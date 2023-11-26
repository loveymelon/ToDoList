//
//  File.swift
//  ToDoList
//
//  Created by 김진수 on 2023/10/23.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var borderWidth: CGFloat {
            set {
                layer.borderWidth = newValue
            }
            get {
                return layer.borderWidth
            }
        }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
