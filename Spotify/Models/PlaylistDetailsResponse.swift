//
//  PlaylistDetailsResponse.swift
//  Spotify
//
//  Created by Teenu Abraham on 10/03/23.
//

import Foundation

struct PlaylistDetailsResponse: Codable{
    let description: String
    let external_urls:[String:String]
    let id: String
    let images:[APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
    
}

struct PlaylistTracksResponse: Codable {
    let items: [playlistItem]
}


struct playlistItem: Codable {
    let track: AudioTrack
}
