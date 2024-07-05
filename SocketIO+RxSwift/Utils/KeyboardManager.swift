//
//  KeyboardManager.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/05.
//

import UIKit
import RxSwift
import RxCocoa

class KeyboardManager {
    
    static let shared = KeyboardManager()
    
    private let disposeBag = DisposeBag()
    
    private init() {}
    
    func keyboardHeight() -> Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                    },
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                    .map { _ -> CGFloat in
                        0
                    }
            ])
            .merge()
    }
    
    func adjustViewForKeyboardHeight(in view: UIView, with keyboardHeight: CGFloat) {
        let offset = keyboardHeight > 0 ? -keyboardHeight : 0
        UIView.animate(withDuration: 0.3) {
            view.transform = CGAffineTransform(translationX: 0, y: offset)
        }
    }
    
    func setupDismissKeyboardGesture(for view: UIView, target: AnyObject, selector: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

}
