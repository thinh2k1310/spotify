//
//  UserProfile.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import Foundation

struct UserProfile : Codable{
    let country : String
    let email : String
    let display_name : String
    let id : String
    let images : [UserImage]
    let product : String
}
struct UserImage : Codable {
    let url : String
}
