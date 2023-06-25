//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 15.06.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? { // вычисляемое свойство, возвращает из массива апки первое окно
        UIApplication.shared.windows.first // синглтон объекта текущего приложения
    }
    
    static func show() { // используется для отображения индикатора загрузки и блокировки UI
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() { // используется для скрытия индикатора загрузки и разблокировки UI
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
