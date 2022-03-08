//
//  CustomLocation.swift
//  ForeCaster
//
//  Created by Samuel Conry-Murray (student LM) on 3/8/22.
//

import Foundation

class customLocation: Codable, ObservableObject{
    var nickname : String!
    var address : String!
    var latLongLink : String!
    func getLink() -> String{
        if address == nil && latLongLink != nil{
            return latLongLink
        }
        else if latLongLink == nil && address != nil{
            return address
        }
        else{
            return "No stored link"
        }
    }
    init(address : String, nickname: String = "" ){
        self.address = address
        self.nickname = nickname
    }
    init(_ latLongLink : String, nickname: String = ""){
        self.latLongLink = latLongLink
        self.nickname = nickname
    }
}

