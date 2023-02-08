//
//  AuthResponse.swift
//  Spotify
//
//  Created by Teenu Abraham on 22/02/23.
//

import Foundation

struct AuthResponse: Codable{
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
