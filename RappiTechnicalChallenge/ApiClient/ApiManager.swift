//
//  ApiManager.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/25/19.
//

import Foundation
import CoreLocation

/// List the base end point to use in the app.
///
/// - apiZomato: Access to the information of 1,5 millions of restaurantes along of 10.000 citys around the world.
enum BaseEndPoint: String {
    case apiZomato = "https://developers.zomato.com/api/v2.1"
}

/// List End points.
///
/// - establishments: List of all restaurants categorized.
/// - popularNearYou: List of popular cuisines around you.
/// - cuisines: List of popular cuisines.
/// - categories: List of all restaurants categorized
enum ApiEndPoints: String {
    case establishmentsGeoCode = "/geocode"
    case mostPopular = "/collections"
    case cuisines = "/cuisines"
    case categories = "/categories"
    case search = "/search"
    case restaurant = "/restaurant"
}

/// List the calls to Web Services
enum ApiManager {
    /// List of all restaurants categorized under a particular restaurant type can obtained using /Search API with Establishment ID and location details as inputs
    ///
    /// - Parameter result:
    static func fetchEstablishmentsWithLocation(coordinates: CLLocationCoordinate2D,
                                            result: @escaping (Result<EstablismentsByLocationModel, ApiServiceError>) -> Void) {
        let urlProfileData = BaseEndPoint.apiZomato.rawValue + ApiEndPoints.establishmentsGeoCode.rawValue
            + "?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)"
        guard let url = URL(string: urlProfileData) else { return }
        ApiClient.shared.fetchData(url: url, completion: result)
    }

    /// Get Foodie and Nightlife Index, list of popular cuisines and nearby restaurants around the given coordinates
    ///
    /// - Parameter result:
    static func fetchMostPopular(result: @escaping (Result<MostPopularRestaurantModel, ApiServiceError>) -> Void) {
        let urlProfileData = BaseEndPoint.apiZomato.rawValue + ApiEndPoints.mostPopular.rawValue + "?city_id=1"
        guard let url = URL(string: urlProfileData) else { return }
        ApiClient.shared.fetchData(url: url, completion: result)
    }
    /// Get a list of categories. List of all restaurants categorized under a particular restaurant type can be obtained using /Search API with Category ID as inputs.
    ///
    /// - Parameter result:
    static func fetchCategories(result: @escaping (Result<CategoriesModel, ApiServiceError>) -> Void) {
        let urlProfileData = BaseEndPoint.apiZomato.rawValue + ApiEndPoints.categories.rawValue
        guard let url = URL(string: urlProfileData) else { return }
        ApiClient.shared.fetchData(url: url, completion: result)
    }
    
    /// Get a list of categories. List of all restaurants categorized under a particular restaurant type can be obtained using /Search API with Category ID as inputs.
    ///
    /// - Parameter result: CategoriesModel
    static func fetchSearchWithId(fetchId: Int,
                            typeId: RestaurantTypeId,
                            result: @escaping (Result<RestaurantCategoryModel, ApiServiceError>) -> Void) {
        let parameterType: String = typeId == .isCategoryId ? "category" : "collection_id"
        let urlProfileData = BaseEndPoint.apiZomato.rawValue + ApiEndPoints.search.rawValue + "?" + parameterType + "=" + String(fetchId)
        guard let url = URL(string: urlProfileData) else { return }
        ApiClient.shared.fetchData(url: url, completion: result)
    }
    
    /// Get a list of categories. List of all restaurants categorized under a particular restaurant type can be obtained using /Search API with Category ID as inputs.
    ///
    /// - Parameter result: CategoriesModel
    static func fetchSearchWithKeyWord(keyWord: String,
                                  result: @escaping (Result<RestaurantCategoryModel, ApiServiceError>) -> Void) {
        let parameterType: String = keyWord
        let urlProfileData = BaseEndPoint.apiZomato.rawValue + ApiEndPoints.search.rawValue + "?" + "q" + "=" + parameterType
        guard let url = URL(string: urlProfileData) else { return }
        ApiClient.shared.fetchData(url: url, completion: result)
    }
    /// Get detailed restaurant information using Zomato restaurant ID. Partner Access is required to access photos and reviews.
    ///
    /// - Parameter result: CategoriesModel
    static func fetchRestaurantWith(resId: Int,
                                       result: @escaping (Result<RestaurantData, ApiServiceError>) -> Void) {
        let parameterType: Int = resId
        let urlProfileData = BaseEndPoint.apiZomato.rawValue + ApiEndPoints.restaurant.rawValue + "?" + "res_id" + "=" + String(parameterType)
        guard let url = URL(string: urlProfileData) else { return }
        ApiClient.shared.fetchData(url: url, completion: result)
    }
}
