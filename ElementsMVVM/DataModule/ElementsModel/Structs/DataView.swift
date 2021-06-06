//
//  DataView.swift
//  PryanikMVVM
//
//  Created by Владимир on 06.06.2021.
//

import Foundation

struct DataView: Decodable {
    let data: [NameData]
    let view: [String]
}

struct NameData: Decodable {
    let name: String
    let data: DataDescription
}

struct DataDescription: Decodable {
    let text: String?
    let url: String?
    let selectedId: Int?
    let variants: [Variants]?
}

struct Variants: Decodable {
    let id: Int
    let text: String
}
