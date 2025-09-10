//
//  BookDTO.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 10/09/2025.
//

struct BookDTO: Codable, Identifiable {
    let id: Int
    let title: String
    let authors: [AuthorDTO]
    let subjects: [String]
    let languages: [String]
    let copyright: Bool
    let formats: FormatsDTO
    let downloadCount: Int
}

extension BookDTO {
    func toDomain() -> Book {
        Book(id: id, title: title, authors: authors.map { Author(name: $0.name) }, formats: Formats(applicationRDFXML: formats.applicationRDFXML, applicationOctetStream: formats.applicationOctetStream, imageJPEG: formats.imageJPEG, textPlainCharsetUsASCII: formats.textPlainCharsetUsASCII, audioMPEG: formats.audioMPEG))
    }
}
