//
//  LocalizableProtocol.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/25/19.
//

import Foundation

/// Protocolo que permite obtener el valor real del string.
protocol LocalizableDelegate {
    var rawValue: String { get }
    var table: String? { get }
    var localized: String { get }
}

extension LocalizableDelegate {
    /// Regresa un valor de tipo Localized especificado por la key (forKey).
    var localized: String {
        return Bundle.main.localizedString(forKey: rawValue, value: nil, table: table)
    }
    /// Nombre del archivo donde se encuentra la key del string a encontrar. Por default es Localizable.string.
    var table: String? {
        return nil
    }
}
