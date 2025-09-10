//
//  BookTests.swift
//  BookTests
//
//  Created by Dimitrios Tsoumanis on 02/09/2025.
//

import Testing
import Foundation
@testable import BookStore

// MARK: - Book Tests
@Suite("Book Domain Model Tests")
struct BookTests {
    
    @Test("Book should be created with valid properties")
    func testBookCreation() {
        // Given
        let author = Author(name: "Jane Austen")
        let formats = Formats(
            applicationRDFXML: "",
            applicationOctetStream: nil,
            imageJPEG: "image/jpeg",
            textPlainCharsetUsASCII: nil,
            audioMPEG: nil
        )
        
        // When
        let book = Book(
            id: 1,
            title: "Pride and Prejudice",
            authors: [author],
            formats: formats
        )
        
        // Then
        #expect(book.id == 1)
        #expect(book.title == "Pride and Prejudice")
        #expect(book.authors.count == 1)
        #expect(book.authors.first?.name == "Jane Austen")
        #expect(book.formats.imageJPEG == "image/jpeg")
    }
    
    @Test("Book should conform to Identifiable")
    func testBookIdentifiable() {
        // Given
        let book = Book.mock(id: 1)
        
        // Then
        #expect(book.id == 1)
    }
}

