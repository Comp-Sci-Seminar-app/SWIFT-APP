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
    var isUsed : Bool = false
    var number : Int!
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
    init(address : String, oneLineAddress: String, nickname: String = "", number: Int ){
        self.address = address
        self.nickname = nickname
    }
    init(_ latLongLink : String, nickname: String = "", number: Int){
        self.latLongLink = latLongLink
        self.nickname = nickname
    }
}

