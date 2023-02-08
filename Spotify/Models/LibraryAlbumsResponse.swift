//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Teenu Abraham on 23/03/23.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
