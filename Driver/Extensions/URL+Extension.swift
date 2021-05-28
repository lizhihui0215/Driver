//
//  URL+Extension.swift
//  Driver
//
//  Created by lizhihui on 2021/5/28.
//

import Foundation

extension URL {
    init?(string: String, withAllowedCharacters allowedCharacters: CharacterSet) {
        guard let urlString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            return nil
        }
        self.init(string: urlString)
    }
}
