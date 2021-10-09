//
//  DataStructures.swift
//  FoeHelper
//
//  Created by George Karavas on 30/9/21.
//

import Foundation

let urlString = "http://127.0.0.1:8080/gkaravas/foeHelper/external/postman"
//let urlString = "http://192.168.1.22:8080/gkaravas/foeHelper/external/postman"
//let urlString = "https://www.gkaravas.com/foeHelper/external/postman"
public struct Technology: Codable, Identifiable{
    public var code: String
    public var id: Int
    public var amount: String?
    public var points: Int?
    public var goods: [Good]?
}

public struct Good: Codable, Identifiable{
    public var code: String
    public var id: Int
    public var age: String?
    public var technologies: [Technology]?
    public var totalTechAmount: Int?
    public var amount: String?
}

public struct Age: Codable, Identifiable{
    public var code: String
    public var id: Int
    public var previous: String?
    public var next: String?
    public var goods: [Good]?
    public var technologies: [Technology]?
}

public struct Post: Encodable{
//    public var user: User?
    public var code: String?
}

public struct ReturnData: Codable{
    public var age: Age?
    public var ages: [Age]?
    public var good: Good?
    public var technology: Technology?
}

