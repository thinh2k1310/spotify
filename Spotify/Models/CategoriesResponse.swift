//
//  CategoriesResponse.swift
//  Spotify
//
//  Created by Truong Thinh on 08/04/2022.
//

import Foundation

struct CategoriesResponse : Codable{
    let categories : CategoryReponse
}
struct CategoryReponse : Codable{
    let items : [Category]
}

struct Category : Codable{
    let icons : [APIImage]
    let id : String
    let name : String
}
