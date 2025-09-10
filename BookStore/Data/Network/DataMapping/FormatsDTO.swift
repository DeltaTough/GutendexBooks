//
//  FormatsDTO.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 10/09/2025.
//

struct FormatsDTO: Codable {
    let applicationRDFXML: String
    let applicationOctetStream: String?
    let imageJPEG: String?
    let textPlainCharsetUsASCII: String?
    let audioMPEG: String?

    private enum CodingKeys: String, CodingKey {
        case applicationRDFXML = "application/rdf+xml"
        case applicationOctetStream = "application/octet-stream"
        case imageJPEG = "image/jpeg"
        case textPlainCharsetUsASCII = "text/plain; charset=us-ascii"
        case audioMPEG = "audio/mpeg"
    }
}
