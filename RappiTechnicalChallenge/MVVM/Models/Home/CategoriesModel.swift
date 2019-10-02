//
//  CategoriesModel.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/25/19.
//

import Foundation

// MARK: - CategoriesModel
struct CategoriesModel: Decodable {
    let categories: [Category]
}

// MARK: - Category
struct Category: Decodable {
    let categories: CategoriesData
}

// MARK: - Categories Data
struct CategoriesData: Decodable {
    let id: Int
    let name: String
}
