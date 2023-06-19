//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 07.06.2023.
//

import Foundation

enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case scope
    case createdAt = "created_at"
}

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}

