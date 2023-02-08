//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Teenu Abraham on 28/02/23.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResposponse
}

struct AlbumsResposponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type: String
    let available_markets:[String]
    let id: String
    var images:[APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists:[Artist]
}



