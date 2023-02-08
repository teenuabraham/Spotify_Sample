//
//  FeaturedPlaylistResponse.swift
//  Spotify
//
//  Created by Teenu Abraham on 28/02/23.
//

import Foundation

struct FeaturedPlaylistResponse: Codable {
    let message: String?
    let playlists: PlaylistResponse
}

struct CategoryPlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let display_name: String
    let external_urls: [String:String]
    let id: String
}
