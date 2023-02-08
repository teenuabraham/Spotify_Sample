//
//  SettingsModel.swift
//  Spotify
//
//  Created by Teenu Abraham on 23/02/23.
//

import Foundation

struct Section {
    let title: String
    let options:[Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
