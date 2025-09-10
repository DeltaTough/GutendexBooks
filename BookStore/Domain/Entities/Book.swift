//
//  Book.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 02/09/2025.
//

struct Book: Identifiable {
    let id: Int
    let title: String
    let authors: [Author]
    let formats: Formats
}

extension Book {
    static func mock(
        id: Int = 1,
        title: String = "Something interesting",
        authors: [Author] = [Author(name: "John Doe")],
        formats: Formats = Formats(applicationRDFXML: "", applicationOctetStream: "", imageJPEG: "image/jpeg", textPlainCharsetUsASCII: "", audioMPEG: "")
    ) -> Book {
        return Book(
            id: id,
            title: title,
            authors: authors,
            formats: formats
        )
    }
}
