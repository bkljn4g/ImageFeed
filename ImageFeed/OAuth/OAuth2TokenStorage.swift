//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 07.06.2023.
//

import UIKit

final class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: OAuthTokenResponseBody.CodingKeys.accessToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: OAuthTokenResponseBody.CodingKeys.accessToken.rawValue)
        }
    }
}
