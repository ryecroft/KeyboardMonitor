//
//  KeyboardMonitor.swift
//  Rockfax
//
//  Created by Stephen Horne on 10/03/2019.
//  Copyright © 2019 Rockfax. All rights reserved.
//

import UIKit


@objc open class KeyboardMonitor: NSObject {
  
  
  private enum KeyboardDisplayChange {
    case show
    case hide
  }
  
  
  @objc open var keyboardVisible = false
  
  
  @objc public static let shared: KeyboardMonitor = KeyboardMonitor()
  
  
  @objc open var keyboardFrame: CGRect = .zero
  @objc open var keyboardWidth: CGFloat { return keyboardFrame.width }
  @objc open var keyboardHeight: CGFloat { return keyboardFrame.height }
  
  private var delegates = NSHashTable<KeyboardMonitorDelegate>.init(options: .weakMemory)
  
  
  override public init() {
    super.init()
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification , object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification , object: nil)
  }
  
  
  @objc open func register(delegate: KeyboardMonitorDelegate) {
    delegates.add(delegate)
  }
  
  
  private func _notifyDelegates(changeType: KeyboardDisplayChange) {
    for delegate in delegates.allObjects {
      delegate.keyboardWillChange?(frame: keyboardFrame)
      switch changeType {
      case .show:
        delegate.keyboardWillShow?()
      case .hide:
        delegate.keyboardWillHide?()
      }
    }
  }
  
  
  @objc func keyboardWillShow(_ notification: NSNotification) {
    guard let kf = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
    keyboardFrame = kf
    _notifyDelegates(changeType: .show)
  }
  
  @objc func keyboardWillHide(_ notification: NSNotification) {
    guard let kf = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
    keyboardFrame = kf
    _notifyDelegates(changeType: .hide)
  }
  
  
  @objc func keyboardDidShow(_ notification: NSNotification) {
    keyboardVisible = true
  }
  
  
  @objc func keyboardDidHide(_ notification: NSNotification) {
    keyboardVisible = false
  }

}
