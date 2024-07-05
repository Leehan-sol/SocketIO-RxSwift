//
//  Utils.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertVC, animated: true, completion: nil)
    }
    
    func showAlertWithOneTF(from viewController: UIViewController, title: String, message: String?, placeholder: String, button1: String, button2: String, completion: @escaping (_ text: String?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        
        let action = UIAlertAction(title: button1, style: .default) { _ in
            let text = alertController.textFields?.first?.text
            completion(text)
        }
        let action2 = UIAlertAction(title: button2, style: .cancel)
        
        alertController.addAction(action)
        alertController.addAction(action2)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
