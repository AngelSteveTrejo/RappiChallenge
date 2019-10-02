//
//  SearchModel.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/30/19.
//

import Foundation

// MARK: - CategoriesModel
struct SearchModel: Decodable {
    let categories: [Search]
}

// MARK: - Category
struct Search: Decodable {
    let categories: CategoriesData
}

// MARK: - Categories Data
struct SearchData: Decodable {
    let id: Int
    let name: String
}
