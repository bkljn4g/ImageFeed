//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 23.06.2023.
//

import UIKit

let AccessKey = "q3wlhrsbHSwgaAaifw5LyVcTFdAoH-JLWq87Yowhqhg" // №2
let SecretKey = "rFyVSUbmsnrY1njuRCAd466WLNyx6RNI0bJ9bg-qunc" // №2
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURl = URL(string: "https://api.unsplash.com/")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

// "q3wlhrsbHSwgaAaifw5LyVcTFdAoH-JLWq87Yowhqhg" - access key №2
// "rFyVSUbmsnrY1njuRCAd466WLNyx6RNI0bJ9bg-qunc" - secret key №2

// "d3-jvTAYCbyT5qpWnRIcQOW32j6EsTTw0rAQd5tasec" - access key №1
// "EOM9ETJR252wxdPvETLy3Q_f9h7gWrUIzvJBINESc2Y" - secret key №1

// "xX8nhOiUpLKMY3-p0Kov3m2nzsbbSYZq2nRpeHFyaPs" - access key №3
// "aJVLu2d3kj93tYkuqogROqHPhQkK-N3kVvdpvupA5HI" - secret key №3

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: AccessKey,
                          secretKey: SecretKey,
                          redirectURI: RedirectURI,
                          accessScope: AccessScope,
                          authURLString: UnsplashAuthorizeURLString,
                          defaultBaseURL: DefaultBaseURl)
    }
}
