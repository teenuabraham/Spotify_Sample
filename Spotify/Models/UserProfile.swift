//
//  UserProfile.swift
//  Spotify
//
//  Created by Teenu Abraham on 10/02/23.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
   // let followers: [String: Bool]
    let href: String?
    let id: String
    let product: String
    let type: String
    let uri: String
    let images:[APIImage]
}



