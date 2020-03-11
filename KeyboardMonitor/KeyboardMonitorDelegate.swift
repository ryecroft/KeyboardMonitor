//
//  File.swift
//  
//
//  Created by Stephen Horne on 10/03/2020.
//

import UIKit

@objc public protocol KeyboardMonitorDelegate {
  
  @objc optional func keyboardWillChange(frame: CGRect)
  
  @objc optional func keyboardWillShow()
  @objc optional func keyboardWillHide()
  
}
