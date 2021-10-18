//
//  DataStructures.swift
//  FoeHelper
//
//  Created by George Karavas on 30/9/21.
//

import Foundation

let servletVersion: Int = 104

let urlString = "http://127.0.0.1:8080/gkaravas/foeHelperTest/external/postman"
//let urlString = "http://192.168.1.22:8080/gkaravas/foeHelperTest/external/postman"
//let urlString = "https://www.gkaravas.com/foeHelper/external/postman"
//let urlString = "http://foe.gkaravas.com/external/postman"
//let urlString = "https://www.gkaravas.com:8443/foeHelper/external/postman"

public struct DetailRow:  Codable, Identifiable{
    public var id: Int
    public var code: String
}

public struct Technology: Codable, Identifiable{
    public var code: String
    public var id: Int
    public var amount: Int?
    public var points: Int?
    public var goods: [Good]?
}

public struct Good: Codable, Identifiable{
    public var code: String
    public var id: Int
    public var age: String?
    public var technologies: [Technology]?
    public var totalTechAmount: Int?
    public var amount: Int?
}

public struct Age: Codable, Identifiable{
    public var code: String
    public var id: Int
    public var previous: String?
    public var next: String?
    public var goods: [Good]?
    public var technologies: [Technology]?
    public var requiredGoods: [Good]?
}

public struct GreatBuildingLevel: Codable, Identifiable{
    public var id: Int
    public var aa: Int

    public var points: Int?
    public var points1: Int?
    public var points2: Int?
    public var points3: Int?
    public var points4: Int?
    public var points5: Int?

    public var arcPoints1: Int?
    public var arcPoints2: Int?
    public var arcPoints3: Int?
    public var arcPoints4: Int?
    public var arcPoints5: Int?

    public var ownerPoints: Int?
    public var ownerPoints1: Int?
    public var ownerPoints2: Int?
    public var ownerPoints3: Int?
    public var ownerPoints4: Int?
    public var ownerPoints5: Int?
}

public struct GreatBuilding: Codable, Identifiable{
    public var code: String
    public var id: Int
    public var age: String?
    public var width: Int?
    public var height: Int?
    public var requiredGoods: [Good]?
    public var levels: [GreatBuildingLevel]?
}

public struct Post: Encodable{
//    public var user: User?
    public var code: String?
    public var id: Int?
    public var arcPercent: Float?
}

public struct ReturnData: Codable{
    public var age: Age?
    public var ages: [Age]?
    public var good: Good?
    public var technology: Technology?
    public var details: [DetailRow]?
    public var greatBuilding: GreatBuilding?
    public var level: GreatBuildingLevel?
}

