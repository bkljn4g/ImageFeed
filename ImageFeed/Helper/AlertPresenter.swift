//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 17.06.2023.
//

import UIKit

final class AlertPresenter {
    func showAlert(in vc: UIViewController, with model: AlertModel, erorr: Error) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion)
        
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> ())?
}
