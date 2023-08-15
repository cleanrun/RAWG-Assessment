//
//  String+Extension.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 15/08/23.
//

import Foundation

extension String {
    func htmlFormattedAttributedString() -> NSAttributedString? {
        guard let htmlData = self.data(using: .unicode) else { return nil }
        return try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
}
