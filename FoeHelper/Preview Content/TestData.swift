//
//  TestData.swift
//  FoeHelper
//
//  Created by George Karavas on 30/9/21.
//

import Foundation

struct TestData{
    static var age: Age = {
        let url = Bundle.main.url(forResource: "Age", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        var value: Age = try! decoder.decode(Age.self, from: data)
        return value
    }()

    static var good: Good = {
        let url = Bundle.main.url(forResource: "Good", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        var value: Good = try! decoder.decode(Good.self, from: data)
        return value
    }()

    static var technology: Technology = {
        let url = Bundle.main.url(forResource: "Technology", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        var value: Technology = try! decoder.decode(Technology.self, from: data)
        return value
    }()

    static var greatBuildings: [DetailRow] = {
        let url = Bundle.main.url(forResource: "GreatBuildings", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
//        var value: [DetailRow] = try! decoder.decode([DetailRow.self], from: data)
        var returnData: ReturnData = try! decoder.decode(ReturnData.self, from: data)
        return returnData.details ?? []
    }()

    static var greatBuilding: GreatBuilding = {
        let url = Bundle.main.url(forResource: "GreatBuilding", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        var value: ReturnData = try! decoder.decode(ReturnData.self, from: data)
        return value.greatBuilding!
    }()

    static var greatBuildingLevel: GreatBuildingLevel = {
        let url = Bundle.main.url(forResource: "GreatBuildingLevel", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        var value: ReturnData = try! decoder.decode(ReturnData.self, from: data)
        return value.level!
    }()

}
