//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 18.06.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> ())?
}
