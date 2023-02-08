//
//  Playlist.swift
//  Spotify
//
//  Created by Teenu Abraham on 10/02/23.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String:String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}