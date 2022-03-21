//
//  SettingsModel.swift
//  Spotify
//
//  Created by Truong Thinh on 21/03/2022.
//

import Foundation

struct Section {
    let title : String
    let options : [Option]
}
struct Option {
    let title : String
    let handler : () -> Void
}
