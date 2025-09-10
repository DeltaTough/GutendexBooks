//
//  Formats.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 06/09/2025.
//

//enum Formats: String {
//    case imageJpeg = "image/jpeg"
//    case audioMpeg = "audio/mpeg"
//    case textPlain = "text/plain; charset=us-ascii"
//    case textHtml  = "text/html"
//    case rdfXml    = "application/rdf+xml"
//    case zip       = "application/octet-stream"
//    case unknown
//}

struct Formats {
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
