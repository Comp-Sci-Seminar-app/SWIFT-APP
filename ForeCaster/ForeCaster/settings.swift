//
//  settings.swift
//  ForeCaster
//
//  Created by Lucas Laje (student LM) on 3/21/22.
//

import Foundation

struct darkMode: Codable{
    var on = false
}

struct idealTemp{
    var tempNum : Int
    var rain = false
    var snow : Int
    var condition : String
    
}
