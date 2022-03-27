//
//  Artist.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import Foundation

struct Artist : Codable {
    let id : String
    let name : String
    let type : String
    let external_urls : [String : String]
}
