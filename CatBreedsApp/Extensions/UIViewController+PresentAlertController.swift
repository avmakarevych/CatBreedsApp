//
//  UIViewController+PresentAlertController.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//

import Foundation
import UIKit

var rootController: UIViewController? {
    guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
        return nil
    }
    
    var root = windowScene.windows.first?.rootViewController
    
    if let presenter = root?.presentedViewController {
        root = presenter
    }
    
    return root
}

func presentAlert(title: String, message: String, primaryAction: UIAlertAction = .ok, secondaryAction: UIAlertAction? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(primaryAction)
    if let secondary = secondaryAction { alert.addAction(secondary) }
    rootController?.present(alert, animated: true, completion: nil)
}

extension UIAlertAction {
    static var cancel: UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
    
    static var ok: UIAlertAction {
        UIAlertAction(title: "OK", style: .cancel, handler: nil)
    }
}
