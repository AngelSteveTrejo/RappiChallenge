//
//  Constants.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/26/19.
//

import Foundation
import UIKit

struct Constants {
    struct CustomColors {
        static let blackCustom = "blackCustom"
        static let brownYell = "brownYell"
        static let grayPosh = "grayPosh"
        static let greenPlant = "greenPlant"
        static let greenShine = "greenShine"
        static let mustard = "mustard"
        static let orangeMexican = "orangeMexican"
        static let whiteGray = "whiteGray"
        static let headerGray = "headerGray"
    }
    
    struct Api {
        static let zomatoHeader = "user-key"
        static let zomatoKey = "5f45e87965bc87c11ee9db591ac27fec"
        static let apiKey = "AIzaSyB00BsWrcR6n1KBk8ap9_Zqm2GPYBtJbdk"
    }
    
    struct PersistentData {
            static let recentViewed = "recentViewed"
    }
    
    struct Font {
        static let forTitleBold = "AppleSDGothicNeo-Bold"
        static let subtitleBold = "AppleSDGothicNeo-SemiBold"
        static let normal = "ppleSDGothicNeo-Regular "
    }
    
    struct Location {
        static let latitude = 40.7128
        static let longitude = -74.0060
    }
    
    struct PlaceHolder {
        static let generalForFood = "placeHolderFood"
    }
    
    struct Header {
        static let height: CGFloat = 30
    }
}
